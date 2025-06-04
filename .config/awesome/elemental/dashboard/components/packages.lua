local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")
local icons = require("icons")

local arch_icon = wibox.widget.imagebox(icons.image["arch-linux"])
arch_icon.forced_height = dpi(28)
arch_icon.forced_width = dpi(28)

local official_title = wibox.widget({
  font = "sans medium 16",
  markup = helpers.colorize_text("Official Packages: ", x.color8),
  widget = wibox.widget.textbox,
})

local official = wibox.widget({
  font = "sans medium 16",
  markup = helpers.colorize_text("Pending...", x.color0),
  widget = wibox.widget.textbox,
})

local aur_title = wibox.widget({
  font = "sans medium 16",
  markup = helpers.colorize_text("AUR Packages: ", x.color8),
  widget = wibox.widget.textbox,
})

local aur = wibox.widget({
  font = "sans medium 16",
  markup = helpers.colorize_text("Pending...", x.color0),
  widget = wibox.widget.textbox,
})

awesome.connect_signal("evil::packages::official", function(count)
  local safe_count = count == nil and 0 or count
  local color = safe_count and x.color8 or count > 50 and x.color1 or x.color2
  official.markup = helpers.colorize_text(safe_count, color)
  official_title.markup = helpers.colorize_text("Official Packages: ", color)
end)

awesome.connect_signal("evil::packages::aur", function(count)
  local safe_count = count == nil and 0 or count
  local color = safe_count and x.color8 or count > 50 and x.color1 or x.color2
  aur.markup = helpers.colorize_text(safe_count, color)
  aur_title.markup = helpers.colorize_text("AUR Packages: ", color)
end)

local update_command = user.terminal .. [[
  yay -Syyu
]]

local update_packages = function()
  awful.spawn(update_command)
  dashboard_hide()
end

local package_widget = wibox.widget({
  {
    {
      arch_icon,
      {
        font = "sans medium 16",
        markup = helpers.colorize_text(" Pending Updates", x.color1),
        widget = wibox.widget.textbox,
      },
      layout = wibox.layout.align.horizontal,
    },
    {
      official_title,
      official,
      layout = wibox.layout.align.horizontal,
    },
    {
      aur_title,
      aur,
      layout = wibox.layout.align.horizontal,
    },
    gap = box_gap,
    layout = wibox.layout.align.vertical,
  },
  margins = box_gap * 4,
  color = "#00000000",
  widget = wibox.container.margin,
})

package_widget:buttons(gears.table.join(
  -- Left click - New fortune
  awful.button({}, 1, update_packages)
))
helpers.add_hover_cursor(package_widget, "hand1")

return package_widget
