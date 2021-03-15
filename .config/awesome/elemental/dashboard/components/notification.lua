local helpers = require("helpers")
local naughty = require("naughty")
local wibox   = require("wibox")

local notification_state = wibox.widget {
    align = "center",
    valign = "center",
    font = "icomoon 32",
    widget = wibox.widget.textbox("")
}

local function update_notification_state_icon()
    if naughty.suspended then
        notification_state.markup = helpers.colorize_text(notification_state.text, x.color8)
    else
        notification_state.markup = helpers.colorize_text(notification_state.text, x.color2)
    end
end

update_notification_state_icon()

return {
  widget = notification_state,
  update = update_notification_state_icon
}
