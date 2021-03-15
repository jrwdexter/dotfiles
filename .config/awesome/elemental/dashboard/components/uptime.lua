local awful   = require("awful")
local helpers = require("helpers")
local wibox   = require("wibox")

local uptime_text = wibox.widget.textbox()
awful.widget.watch("uptime -p | sed 's/^...//'", 60, function(_, stdout)
    -- Remove trailing whitespaces
    local out = stdout:gsub('^%s*(.-)%s*$', '%1')
    uptime_text.text = out
end)

local uptime = wibox.widget {
    {
        align = "center",
        valign = "center",
        font = "icomoon 20",
        markup = helpers.colorize_text("", x.color3),
        widget = wibox.widget.textbox()
    },
    {
        align = "center",
        valign = "center",
        font = "sans medium 16",
        widget = uptime_text
    },
    spacing = dpi(15),
    layout = wibox.layout.fixed.horizontal
}

return uptime
