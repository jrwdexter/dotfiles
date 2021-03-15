local awful   = require("awful")
local gears   = require("gears")
local helpers = require("helpers")
local wibox   = require("wibox")

local function create_bookmark(name, path, color, hover_color)
    local bookmark = wibox.widget.textbox()
    bookmark.font = "sans bold 22"
    -- bookmark.text = wibox.widget.textbox(name:sub(1,1):upper()..name:sub(2))
    bookmark.markup = helpers.colorize_text(name, color)
    bookmark.align = "center"
    bookmark.valign = "center"

    -- Buttons
    bookmark:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            awful.spawn.with_shell(user.file_manager.." "..path)
            dashboard_hide()
        end),
        awful.button({ }, 3, function ()
            awful.spawn.with_shell(user.terminal.." -e 'ranger' "..path)
            dashboard_hide()
        end)
    ))

    -- Hover effect
    bookmark:connect_signal("mouse::enter", function ()
        bookmark.markup = helpers.colorize_text(name, hover_color)
    end)
    bookmark:connect_signal("mouse::leave", function ()
        bookmark.markup = helpers.colorize_text(name, color)
    end)

    helpers.add_hover_cursor(bookmark, "hand1")

    return bookmark
end

local function discover_git_repos()
  local src_dir = os.getenv("SRC")
  local rg_cmd  = 'rg --files --hidden --no-messages -g HEAD '..src_dir..' | rg .git.HEAD | sed -E s/..git.HEAD$//'
end

local bookmarks = wibox.widget {
    create_bookmark("home", os.getenv("HOME"), x.color1, x.color9),
    create_bookmark("downloads", user.dirs.downloads, x.color2, x.color10),
    create_bookmark("music", user.dirs.music, x.color6, x.color14),
    create_bookmark("pictures", user.dirs.pictures, x.color4, x.color12),
    create_bookmark("wallpapers", user.dirs.wallpapers, x.color5, x.color13),
    create_bookmark("screenshots", user.dirs.screenshots, x.color3, x.color11),
    spacing = dpi(15),
    layout = wibox.layout.fixed.vertical
}

return bookmarks
