local awful = require("awful")
local helpers = require("../helpers")

local temp_file = "/tmp/awesome-evil-screensaver-status"
local update_interval = 5 * 60

local check_script = [[
  if xset q | grep "DPMS is Disabled"; then
    awesome-client "awesome.emit_signal('evil::screensaver::off')"
    echo '{ "screensaver_status": false }'
  else
    awesome-client "awesome.emit_signal('evil::screensaver::on')"
    echo '{ "screensaver_status": true }'
  fi
]]

local toggle_script = [[
  if xset q | grep "DPMS is Disabled"; then
    xset s on
    xset +dpms
    awesome-client "awesome.emit_signal('evil::screensaver::on')"
  else
    xset s off
    xset -dpms
    awesome-client "awesome.emit_signal('evil::screensaver::off')"
  fi
]]

local function toggle_screensaver()
  awful.spawn.with_shell(toggle_script)
end

helpers.remote_watch(check_script, update_interval, temp_file, function(stdout)
end)

awesome.connect_signal("evil::screensaver::toggle", toggle_screensaver)
