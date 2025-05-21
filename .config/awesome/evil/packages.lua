-- Provides:
-- evil::packages::official
-- evil::packages::aur
local awful = require("awful")
local helpers = require("helpers")

local update_interval = 300

local official_packages = [[
  sh -c "
  checkupdates | wc -l
"]]

local aur_packages = [[
  sh -c "
  yay -Qum | wc -l
"]]

-- Periodically update packages
helpers.remote_watch(official_packages, update_interval, "/tmp/awesome-evil-arch-packages", function(stdout)
    awesome.emit_signal("evil::packages::official", tonumber(stdout))
end)

helpers.remote_watch(aur_packages, update_interval, "/tmp/awesome-evil-aur-packages", function(stdout)
    awesome.emit_signal("evil::packages::aur", tonumber(stdout))
end)
