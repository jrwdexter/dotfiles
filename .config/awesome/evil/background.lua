local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local interval = 60 * 60 * 4 -- 4 hours

timer = gears.timer {
  timeout = interval,
  call_now = true,
  autostart = true,
  single_shot = false,
  callback = function()
    awful.spawn.easy_async_with_shell("feh --bg-fill --randomize "..(user.dirs.wallpapers))
  end
}
