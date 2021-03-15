local awful = require("awful")
local beautiful = require("beautiful")

return {
  -- Appearance
  box_radius = beautiful.dashboard_box_border_radius or dpi(18),
  box_gap = dpi(9),

  -- Get screen geometry
  screen_width = awful.screen.focused().geometry.width,
  screen_height = awful.screen.focused().geometry.height
}
