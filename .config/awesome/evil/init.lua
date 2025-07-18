-- Monitoring
require("evil.cpu")
require("evil.ram")
require("evil.temperature")
require("evil.battery")
require("evil.disk")
require("evil.github")
require("evil.vpn")

-- User controlled
require("evil.volume")
require("evil.mpd")
require("evil.screensaver")
require("evil.brightness")
-- require("evil.spotify")

-- Internet access required
-- Note: These daemons use a temp file to store the retrieved values in order
-- to check its modification time and decide if it is time to update or not.
-- No need to worry that you will be updating too often when restarting AwesomeWM :)
-- This is useful because some APIs have a limit on the number of calls per hour.
require("evil.coronavirus")
--require("evil.vaccines") -- HAVE A VACCINE! Don't need this anymore :-)
require("evil.gcal")
require("evil.weather")
require("evil.timer")
require("evil.background")
require("evil.profile")
require("evil.packages")
