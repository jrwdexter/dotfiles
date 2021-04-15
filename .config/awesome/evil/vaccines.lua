-- Provides:
-- evil::vaccine
--      address (integer)
--      url (integer)
--      name (integer)
--      zip (integer)
local awful = require("awful")
local helpers = require("helpers")
local json = require("json")

local update_interval = 60 * 60 * .1 -- 6 minutes
local state = user.vaccine_state or "MN"
local zip_codes = user.vaccine_zip_codes or {"55127"}
local temp_file = "/tmp/awesomewm-evil-vaccines"
local ifttt_key = user.ifttt_key
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
  awesome.emit_signal("evil::vaccines", vaccine_data)

  if not (vaccine_data[1] == nil) then
    local ifttt_payload = {
      value1 = vaccine_data[1].name,
      value2 = vaccine_data[1].url,
    }
    local curl_command = [[
      curl -X POST -H "Content-Type: application/json" -d ']]..json.encode(ifttt_payload)..[[' https://maker.ifttt.com/trigger/vaccine_available/with/key/]]..ifttt_key
    awful.spawn.easy_async_with_shell(curl_command)
  end
end)
