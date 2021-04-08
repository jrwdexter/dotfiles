-- Provides:
-- evil::vaccine
--      address (integer)
--      url (integer)
--      name (integer)
--      zip (integer)
local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")
local naughty = require("naughty")
local json = require("json")

local update_interval = 60 * 60 * .01 -- 30 minutes
local state = user.vaccine_state or "MN"
local zip_codes = user.vaccine_zip_codes or {"55127"}
local temp_file = "/tmp/awesomewm-evil-vaccines"
local vaccine_script

local zip_code_selects
for k,zip in pairs(zip_codes) do
  if zip_code_selects == nil then
    zip_code_selects = '"'..zip..'"'
  else
    zip_code_selects = '"'..zip..'", '..zip_code_selects
  end
end

vaccine_script = [[
  sh -c '
  state="]]..state..[["
  zip_codes='"'"']]..zip_code_selects..[['"'"'
  vaccines=$(curl "https://www.vaccinespotter.org/api/v0/states/$state.json" 2>/dev/null)
  vaccines_filtered=$(
    echo $vaccines |
    jq -c ".features[] |
      select(.properties.postal_code == ($zip_codes)) |
      {
        name:                   .properties.name,
        url:                    .properties.url,
        address:                .properties.address,
        state:                  .properties.state,
        postal_code:            .properties.postal_code,
        appointments_available: .properties.appointments_available
      }" |
      jq "select(.appointments_available == true)" |
    jq -s)

    echo $vaccines_filtered']]

helpers.remote_watch(vaccine_script, update_interval, temp_file, function(stdout)
  vaccine_data = json.decode(stdout)
  gears.debug.dump(vaccine_data)

  if not (vaccine_data[1] == nil) then
    awesome.emit_signal("evil::vaccines", vaccine_data)
  end
    -- local cases_total = stdout:match('^CTOTAL@(.*)@CTODAY')
    -- local cases_today = stdout:match('CTODAY@(.*)@DTOTAL')
    -- local deaths_total = stdout:match('DTOTAL@(.*)@DTODAY')
    -- local deaths_today = stdout:match('DTODAY@(.*)@')

    -- If it is found, we assume the command succeeded

    -- if cases_total then
        -- awesome.emit_signal("evil::coronavirus", cases_total, cases_today, deaths_total, deaths_today)
    -- else
        -- Remove temp_file to force an update the next time
        -- awful.spawn.with_shell("rm "..temp_file)
        -- awesome.emit_signal("evil::coronavirus", -1, -1, -1, -1)
    -- end
end)
