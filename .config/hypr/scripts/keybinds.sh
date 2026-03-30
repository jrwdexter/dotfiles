#!/usr/bin/env bash
# Show Hyprland keybindings in rofi, parsed from keys.conf

KEYS_CONF="$HOME/.config/hypr/keys.conf"

awk '
BEGIN { section = "" }

# Track section headers (the line after ######)
/^# ###+/ {
    getline
    if (/^# [A-Z]/) {
        section = $0
        gsub(/^# +/, "", section)
        gsub(/ *\(.*\)/, "", section)
    }
    next
}

# Skip all comment and blank lines
/^#/ || /^$/ { next }

# Parse bind lines
/^bind/ {
    split($0, parts, ",")
    mod = parts[1]
    gsub(/^bind[a-z]* *= */, "", mod)
    gsub(/\$mainMod/, "Super", mod)
    gsub(/ +/, "+", mod)
    gsub(/^ */, "", mod)

    key = parts[2]
    gsub(/^ +| +$/, "", key)

    combo = mod "+" key

    # Build action from dispatcher + args
    action = ""
    for (i = 3; i <= length(parts); i++) {
        if (i > 3) action = action ","
        action = action parts[i]
    }
    gsub(/^ +| +$/, "", action)

    # Clean up exec commands
    if (action ~ /^exec, +/) {
        sub(/^exec, +/, "", action)
        gsub(/\$/, "", action)
        if (length(action) > 50) action = substr(action, 1, 47) "..."
    }

    printf "%-22s  %-28s  %s\n", section, combo, action
}
' "$KEYS_CONF" | rofi -dmenu -i -p " Keybindings" -no-custom -theme-str '
window { width: 60%; }
listview { lines: 25; }
'
