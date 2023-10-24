local file_helpers = require "file_helpers"
awesome.connect_signal("evil::profile::change_complete", function(active_profile)
  file_helpers.overwrite_to('/tmp/awesome-evil-profile', active_profile)
end)
