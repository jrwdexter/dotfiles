-- Provides:
-- evil::volume
--      percentage (integer)
--      muted (boolean)
-- evil::microphone
--      muted (boolean)
local awful = require("awful")
local gears = require("gears")

local volume_old = -1
local muted_old = -1
local function emit_volume_info()
  -- Get volume info of the currently active sink
  -- The currently active sink has a star `*` in front of its index
  -- In the output of `pacmd list-sinks`, lines +7 and +11 after "* index:"
  -- contain the volume level and muted state respectively
  -- This is why we are using `awk` to print them.
  awful.spawn.easy_async_with_shell("pactl get-default-sink", function(currentSink)
    currentSink = currentSink:gsub("^%s", ""):gsub("%s$", ""):gsub("\n", "")
    awful.spawn.easy_async_with_shell(
      "pactl list | awk '/^Sink #/{nr[NR+2];nr[NR+8];nr[NR+9]};NR in nr' | grep -A2 " .. currentSink .. " | tail -n2",
      function(stdout)
        local muted = stdout:match("Mute:(%s+)[yes]")
        local volume = stdout:match("(%d+)%%")
        local muted_int = muted and 1 or 0
        local volume_int = tonumber(volume)
        -- Only send signal if there was a change
        -- We need this since we use `pactl subscribe` to detect
        -- volume events. These are not only triggered when the
        -- user adjusts the volume through a keybind, but also
        -- through `pavucontrol` or even without user intervention,
        -- when a media file starts playing.
        if volume_int ~= nil and (volume_int ~= volume_old or muted_int ~= muted_old) then
          awesome.emit_signal("evil::volume", volume_int, muted)
          volume_old = volume_int
          muted_old = muted_int
        end
      end
    )
  end)
end

local function emit_microphone_info()
  -- Use tail to grab the last line of the output (which refers to the microphone)
  awful.spawn.easy_async_with_shell("pacmd list-sources | grep muted | tail -1 | awk '{print $2}'", function(stdout)
    -- Remove trailing whitespace
    local muted = stdout:gsub("^%s*(.-)%s*$", "%1")
    awesome.emit_signal("evil::microphone", muted == "yes")
  end)
end

-- Run once to initialize widgets
emit_volume_info()
emit_microphone_info()

-- Sleeps until pactl detects an event (volume up/down/toggle mute)
local volume_script = [[
    bash -c "
    pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #\"
    "]]

-- Sleeps until pactl detects an event (microphone volume up / down / (un)mute)
local microphone_script = [[
  bash -c '
  pactl subscribe 2> /dev/null | grep --line-buffered "source #"
  ']]

-- Kill old pactl subscribe processes
awful.spawn.easy_async_with_shell(
  "ps x | grep \"pactl subscribe\" | grep -v grep | awk '{print $1}' | xargs kill",
  function()
    -- Run emit_volume_info() with each line printed
    awful.spawn.with_line_callback(volume_script, {
      stdout = function(line)
        emit_volume_info()
      end,
    })
    -- Run emit_microphone_info() with each line printed
    awful.spawn.with_line_callback(microphone_script, {
      stdout = function(line)
        emit_microphone_info()
      end,
    })
  end
)
