local awful = require("awful")
local helpers = require("helpers")
local naughty = require("naughty")

local update_interval = 60 * 15
local temp_file = "/tmp/awesome-evil-vpn-status"

local mozilla_status_script = [=[ if [[ $(mozillavpn status | grep "VPN state: on") ]]; then echo "enabled"; else echo "disabled"; fi ]=]

local handle_vpn_status = function(stdout, _, _, code)
  if not code == nil and code ~= 0 then
    naughty.notify({ title = "VPN Error", message = "Could not detect VPN status", urgency = "normal" })
  elseif stdout:gsub("%s*", "") == "enabled" then
    awesome.emit_signal("evil::vpn::enabled")
  else
    awesome.emit_signal("evil::vpn::disabled")
  end
end

--awesome.connect_signal("startup", function()
--awful.spawn.easy_async_with_shell(mozilla_status_script, handle_vpn_status)
--end)

helpers.remote_watch(mozilla_status_script, update_interval, temp_file, handle_vpn_status)
