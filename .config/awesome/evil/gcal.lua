-- Provides:
-- evil::gcal
--      agenda (table)
local awful = require("awful")
local helpers = require("helpers")
local naughty = require("naughty")
local gears = require("gears")
local json = require("json")

local update_interval = 60 * 15 -- 15 minutes
local temp_file = "/tmp/awesomewm-evil-gcal"
local gcal_script = function()
  local calendar_email = user.get_active_profile().calendar_email
  local client_id = user.get_active_profile().google_oauth.client_id
  local client_secret = user.get_active_profile().google_oauth.client_secret
  local start_date = os.date("%Y-%m-%dT%H:%M:%S", os.time())
  local end_time = {
    year = os.date("%Y"),
    month = os.date("%m"),
    day = os.date("%d"),
    hour = 23,
    min = 59,
  }
  local end_date = os.date("%Y-%m-%dT%H:%M:%S", os.time(end_time))
  return [[
        sh -c '
        calendar_email="]] .. calendar_email .. [["
        start_date="]] .. start_date .. [["
        end_date="]] .. end_date .. [["
        client_id="]] .. client_id .. [["
        client_secret="]] .. client_secret .. [["
        event_json=$(
          gcalcli --calendar $calendar_email search "*" $start_date $end_date --details all --nodeclined --tsv 2>/dev/null | jq -Rs '\''
            split("\n") | map(split("\t")) |
              map(select(.[0] != null and .[0] != "id") | {
                "start_date": (.[1] + "T" + .[2]),
                "end_date": (.[3] + "T" + .[4]),
                "link": .[5],
                "video": .[6],
                "description": .[9]
              })
          '\'' | jq '\''[.[] | select(.start_date | test("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}"))]'\''
        )
        echo $event_json ' ]]
end

helpers.remote_watch(gcal_script, update_interval, temp_file, function(stdout)
  -- If it is found, we assume the command succeeded
  if stdout then
    awesome.emit_signal("evil::gcal", json.decode(stdout))
  else
    -- Remove temp_file to force an update the next time
    awful.spawn.with_shell("rm " .. temp_file)
    awesome.emit_signal("evil::gcal", -1, -1, -1, -1)
  end
end, "evil::profile::change_complete")
