local helpers = require("helpers")
local wibox   = require("wibox")

local screenshot = wibox.widget {
    align = "center",
    valign = "center",
    font = "icomoon 32",
    markup = helpers.colorize_text("", x.color3),
    widget = wibox.widget.textbox()
}

return screenshot
