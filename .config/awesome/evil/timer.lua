local awful = require('awful')
local icons = require('icons')
local gears = require('gears')
local naughty = require('naughty')

local timer_on = false
local start_time
local clock_icon = icons.image.clock
local star_icon = icons.image.star_full
local output_file = '/tmp/awesome-evil-timer'
-- local timer_started_at

awesome.connect_signal("evil::toggle_timesheet", function()
  timer_on = not timer_on
  if timer_on then
    -- Timer has been started
    start_time = os.date('%T')
    naughty.notification({title = 'Work started', text = 'Time has started for work', timeout = 4, icon = clock_icon, app_name = "Timer"})
  else
    -- Timer has been ended
    local end_time = os.date('%T')
    local start_hour, start_min, start_sec = start_time:match('(%d%d):(%d%d):(%d%d)')
    local end_hour, end_min, end_sec = start_time:match('(%d%d):(%d%d):(%d%d)')
    local total_seconds = (end_hour * 60 *60 + end_min * 60 + end_sec) - (start_hour * 60 *60 + start_min * 60 + start_sec)
    local worked_time = math.floor(total_seconds % 360) / 10

    naughty.notification({title = 'Work completed!', text = 'You have worked '..worked_time..' hours', timeout = 4, icon = star_icon, app_name = "Timer"})

    -- Append to file
    awful.spawn.easy_async_with_shell('date -r '..output_file..' +%s', function(last_update, _, __, exitcode)
      if exitcode == 1 then
        -- Write file
        awful.spawn.easy_async_with_shell('echo "'..start_time..' '..end_time..'" > '..output_file)
      else
        local diff_day = not (os.date('%d', tonumber(last_update)) == os.date('%d'))
        if diff_day then
          awful.spawn.easy_async_with_shell('echo "'..start_time..' '..end_time..'" | tee '..output_file)
        else
          awful.spawn.easy_async_with_shell('echo "'..start_time..' '..end_time..'" | tee -a '..output_file)
        end
      end
    end)
  end
end)
