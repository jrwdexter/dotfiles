local awful = require("awful")
local filesystem = require("gears.filesystem")

local autolocker = {}

autolocker.init = function()
  awful.spawn.easy_async_with_shell('which xautolock', function (xautolock_path)
    if xautolock_path and filesystem.file_executable(xautolock_path) then
      awful.spawn.with_shell('pkill -9 xautolock; xautolock -timer '..user.lock_duration..' -locker \'awesome-client "awesome.emit_signal(\\"evil::lock\\")"\' -detectsleep')
    end
  end)
end

return autolocker
