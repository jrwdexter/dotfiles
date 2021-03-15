local awful   = require("awful")
local gears   = require("gears")
local helpers = require("helpers")
local wibox   = require("wibox")

local fortune_command = "fortune -n 140 -s"
local fortune_update_interval = 3600
-- local fortune_command = "fortune -n 140 -s computers"
local fortune = wibox.widget {
    font = "sans medium 16",
    text = "Loading your cookie...",
    widget = wibox.widget.textbox
}

local update_fortune = function()
    awful.spawn.easy_async_with_shell(fortune_command, function(out)
        -- Remove trailing whitespaces
        out = out:gsub('^%s*(.-)%s*$', '%1')
        fortune.markup = "<i>"..helpers.colorize_text(out, x.color4).."</i>"
    end)
end

gears.timer {
    autostart = true,
    timeout = fortune_update_interval,
    single_shot = false,
    call_now = true,
    callback = update_fortune
}

local fortune_widget = wibox.widget {
    {
        nil,
        fortune,
        layout = wibox.layout.align.horizontal,
    },
    margins = box_gap * 4,
    color = "#00000000",
    widget = wibox.container.margin
}

fortune_widget:buttons(gears.table.join(
    -- Left click - New fortune
    awful.button({ }, 1, update_fortune)
))
helpers.add_hover_cursor(fortune_widget, "hand1")

return fortune_widget
