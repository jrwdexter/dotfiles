local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local naughty = require("naughty")

-- User widget
local user_picture_container = wibox.container.background()
-- user_picture_container.shape = gears.shape.circle
user_picture_container.shape = helpers.prrect(dpi(60), true, true, false, true)
user_picture_container.forced_height = dpi(210)
user_picture_container.forced_width = dpi(210)

local user_picture = wibox.widget({
  {
    wibox.widget.imagebox(user.get_active_profile().profile_picture),
    widget = user_picture_container,
  },
  shape = helpers.rrect(box_radius / 2),
  widget = wibox.container.background,
})
user_picture_container:connect_signal("button::press", function()
  awesome.emit_signal("evil::profile::change")
end)
helpers.add_hover_cursor(user_picture_container, "hand1")
local username = os.getenv("USER")
local user_text = wibox.widget.textbox(username:upper())
user_text.font = "San Francisco Display Heavy 30"
user_text.align = "center"
user_text.valign = "center"

local host_text = wibox.widget.textbox()
awful.spawn.easy_async_with_shell("cat /proc/sys/kernel/hostname", function(out)
  -- Remove trailing whitespaces
  out = out:gsub("^%s*(.-)%s*$", "%1")
  out = out:gsub("^([^.]*).*", "%1")
  host_text.markup = helpers.colorize_text("@" .. out, x.color8)
end)
-- host_text.markup = "<span foreground='" .. x.color8 .."'>" .. minutes.text .. "</span>"
host_text.font = "monospace 24"
host_text.align = "center"
host_text.valign = "center"

local user_widget = wibox.widget({
  user_picture,
  helpers.vertical_pad(dpi(36)),
  user_text,
  helpers.vertical_pad(dpi(6)),
  host_text,
  layout = wibox.layout.fixed.vertical,
})

awesome.connect_signal("evil::profile::change_complete", function()
  user_widget:remove(1)

  local new_user_picture = wibox.widget({
    {
      wibox.widget.imagebox(user.get_active_profile().profile_picture),
      widget = user_picture_container,
    },
    shape = helpers.rrect(box_radius / 2),
    widget = wibox.container.background,
  })
  user_widget:insert(1, new_user_picture)
end)

return user_widget
