#!/bin/bash
# ##############################################################################
# REFLOW SCRIPT
# Moves windows to their designated workspaces and workspaces to correct monitors
# Parses windowrules.conf and workspace.conf for the source of truth
# ##############################################################################

HYPR_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
WINDOWRULES_FILE="$HYPR_CONFIG_DIR/windowrules.conf"

# Build workspace rules by parsing windowrules.conf
# Returns: "pattern|workspace" lines
parse_workspace_rules() {
    awk '
    /^windowrule \{/,/^\}/ {
        if (/match:class *= */) {
            gsub(/.*match:class *= */, "")
            gsub(/[\r\n]/, "")
            pattern = $0
        }
        if (/workspace *= *[0-9]+/) {
            gsub(/.*workspace *= */, "")
            gsub(/[^0-9].*/, "")
            ws = $0
        }
    }
    /^\}/ {
        if (pattern != "" && ws != "") {
            print pattern "|" ws
        }
        pattern = ""
        ws = ""
    }
    ' "$WINDOWRULES_FILE"
}

# Get target workspace for a window class by matching against parsed rules
get_target_workspace() {
    local class=$1
    local rules="$2"

    while IFS='|' read -r pattern workspace; do
        # Remove ^ and $ anchors for matching, keep the core pattern
        core_pattern="${pattern#^}"
        core_pattern="${core_pattern%$}"

        if [[ "$class" =~ $core_pattern ]]; then
            echo "$workspace"
            return
        fi
    done <<< "$rules"
}

# Workspace to monitor mappings (from workspace.conf)
# Workspaces 1-7 go to external monitor (first available DP-*)
# Workspaces 8-10 go to laptop (eDP-1)
get_target_monitor() {
    local ws=$1
    if [[ $ws -ge 8 && $ws -le 10 ]]; then
        echo "eDP-1"
    else
        # Find the first available external monitor
        local monitor=$(hyprctl monitors -j | jq -r '.[].name' | grep -E '^DP-' | head -1)
        if [[ -n "$monitor" ]]; then
            echo "$monitor"
        else
            # Fallback to eDP-1 if no external monitor
            echo "eDP-1"
        fi
    fi
}

echo "Starting reflow..."

# Parse rules once
echo "Parsing windowrules.conf..."
RULES=$(parse_workspace_rules)

# Step 1: Move windows to their correct workspaces
echo "Moving windows to correct workspaces..."
hyprctl clients -j | jq -c '.[]' | while read -r client; do
    address=$(echo "$client" | jq -r '.address')
    class=$(echo "$client" | jq -r '.class')
    current_ws=$(echo "$client" | jq -r '.workspace.id')
    floating=$(echo "$client" | jq -r '.floating')
    pinned=$(echo "$client" | jq -r '.pinned')

    # Skip special workspaces, floating, or pinned windows
    if [[ $current_ws -lt 0 ]] || [[ "$floating" == "true" ]] || [[ "$pinned" == "true" ]]; then
        continue
    fi

    target_ws=$(get_target_workspace "$class" "$RULES")

    if [[ -n "$target_ws" ]] && [[ "$current_ws" != "$target_ws" ]]; then
        echo "  Moving $class ($address) from workspace $current_ws to $target_ws"
        hyprctl dispatch movetoworkspacesilent "$target_ws,address:$address"
    fi
done

# Step 2: Move workspaces to correct monitors
echo "Moving workspaces to correct monitors..."
for ws in {1..10}; do
    target_monitor=$(get_target_monitor "$ws")

    # Check if workspace exists and get its current monitor
    ws_info=$(hyprctl workspaces -j | jq -c ".[] | select(.id == $ws)")
    if [[ -n "$ws_info" ]]; then
        current_monitor=$(echo "$ws_info" | jq -r '.monitor')

        if [[ "$current_monitor" != "$target_monitor" ]]; then
            echo "  Moving workspace $ws from $current_monitor to $target_monitor"
            hyprctl dispatch moveworkspacetomonitor "$ws $target_monitor"
        fi
    fi
done

echo "Reflow complete!"
notify-send -t 2000 "Hyprland" "Window reflow complete"
