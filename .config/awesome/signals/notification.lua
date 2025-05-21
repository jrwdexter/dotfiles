local naughty = require("naughty")
local awful = require("awful")

naughty.connect_signal("request::display", function(notification)
  local code = notification.message:match("[ ](%d%d%d%d%d%d)[ %.]?$")
  if code then
    -- Ensure actions table exists
    notification.actions = notification.actions or {}
    local lcode = code:match("%d%d%d%d%d%d")

    -- Append a named action
    local copy_action = naughty.action({ name = "Copy Code" })
    copy_action:connect_signal("invoked", function()
      awful.spawn.with_shell(
        "echo -n '" .. lcode .. "' | xclip -selection clipboard && notify-send 'Code copied to clipboard'"
      )
    end)
    table.insert(notification.actions, copy_action)
  end
end)
