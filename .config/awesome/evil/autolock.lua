local awful      = require("awful")
local filesystem = require("gears.filesystem")

local autolocker = {}

autolocker.init = function()
  awful.spawn.easy_async_with_shell('which xautolock', function (xautolock_path)
    local cleaned_xautolock_path = xautolock_path:gsub('^%s*', ''):gsub('%s*$', '')
    if cleaned_xautolock_path and filesystem.file_executable(cleaned_xautolock_path) then
      local xautolock_cmd = 'pkill -9 xautolock; xautolock -time '..user.lock_duration..' -locker \'awesome-client "awesome.emit_signal(\\"evil::lock\\")"\' -detectsleep'
      awful.spawn.with_shell(xautolock_cmd)
    end
  end)
end

return autolocker
