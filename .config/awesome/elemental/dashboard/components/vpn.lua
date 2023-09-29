local helpers = require("helpers")
local wibox = require("wibox")
local naughty = require("naughty")
local apps = require("apps")

local prior_vpn_status = false

local vpn = wibox.widget({
  align = "center",
  valign = "center",
  font = "icomoon 32",
  markup = helpers.colorize_text(" 󱦚 ", x.color15),
  widget = wibox.widget.textbox(),
})

local reactivate_action = naughty.action({ name = "Reactivate" })

reactivate_action:connect_signal("invoked", function()
  apps.toggle_vpn()
end)

awesome.connect_signal("evil::vpn::enabled", function()
  vpn.markup = helpers.colorize_text(" 󰦝 ", x.color3)
  if prior_vpn_status == false then
    prior_vpn_status = true
    naughty.notify({
      app_name = "VPN",
      title = "VPN Activated!",
      message = "All traffic is now protected",
      icon = " 󰦝 ",
      preset = naughty.config.presets.low,
    })
  end
end)

awesome.connect_signal("evil::vpn::disabled", function()
  vpn.markup = helpers.colorize_text(" 󱦚 ", x.color15)
  if prior_vpn_status == true then
    prior_vpn_status = false
    naughty.notify({
      app_name = "VPN",
      title = "VPN Deactivated",
      message = "VPN is no longer active",
      icon = " 󱦚 ",
      preset = naughty.config.presets.critical,
      urgency = "critical",
      actions = { reactivate_action },
    })
  end
end)

return vpn
