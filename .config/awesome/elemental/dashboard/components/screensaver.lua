local helpers = require("helpers")
local wibox   = require("wibox")
local naughty = require("naughty")

local prior_screensaver_status = true

local screensaver = wibox.widget {
    align = "center",
    valign = "center",
    font = "icomoon 32",
    markup = helpers.colorize_text("󰍹 ", x.color4),
    widget = wibox.widget.textbox()
}

awesome.connect_signal("evil::screensaver::off", function()
  screensaver.markup = helpers.colorize_text("󰍹 ", x.color15)
  if prior_screensaver_status == true then
    prior_screensaver_status = false
    naughty.notify({
      app_name = "Screensaver",
      title = "Screensaver disabled",
      message = "Screensaver and DPMS are now off",
      icon = "󰍹 ",
      preset = naughty.config.presets.low,
    })
  end
end)

awesome.connect_signal("evil::screensaver::on", function()
  screensaver.markup = helpers.colorize_text("󰍹 ", x.color4)
  if prior_screensaver_status == false then
    prior_screensaver_status = true
    naughty.notify({
      app_name = "Screensaver",
      title = "Screensaver enabled",
      message = "Screensaver and DPMS are now on",
      icon = "󰍹 ",
      preset = naughty.config.presets.low,
    })
  end
end)

return screensaver
