local awful = require("awful")
local naughty = require("naughty")
local helpers = require("helpers")
local icons = require("icons")
local notifications = require("notifications")
local json = require("json")

local apps = {}

apps.notes = function()
  helpers.run_or_raise({ instance = user.notes }, false, user.notes, { switchtotag = true })
end

apps.todo = function()
  helpers.run_or_raise({ instance = user.todo }, false, user.todo, { switchtotag = true })
end

apps.mpsyt = function()
  helpers.run_or_raise({ instance = "mpsyt" }, false, user.mpsyt, { switchtotag = true })
end

apps.docker = function()
  helpers.run_or_raise({ instance = "docker", class = "docker" }, true, user.dev.docker, { switchtotag = true })
end

apps.browser = function()
  helpers.run_or_raise({ class = "^" .. user.browser .. "$" }, false, user.browser)
end
apps.dev_browser = function()
  helpers.run_or_raise({ class = user.dev.browser_class }, false, user.dev.browser)
end
apps.api_explorer = function()
  helpers.run_or_raise({ instance = user.dev.api_explorer }, true, user.dev.api_explorer, { switchtotag = true })
end
apps.fe_ide = function()
  helpers.run_or_raise({ class = user.dev.fe_ide_class }, false, user.dev.fe_ide)
end
apps.be_ide = function()
  helpers.run_or_raise({ class = user.dev.be_ide_class }, false, user.dev.be_ide)
end
apps.be_terminal = function()
  helpers.run_or_raise({ instance = "be_terminal" }, false, user.dev.be_terminal)
end
apps.file_manager = function()
  awful.spawn(user.file_manager)
end
apps.gui_file_manager = function()
  awful.spawn(user.gui_file_manager)
end
apps.chat = function()
  helpers.run_or_raise({ class = user.chat_class }, false, user.chat, { switchtotag = true })
end
apps.sound_selector = function()
  awful.spawn.with_shell('rofi -show rofi-sound -modi "rofi-sound:rofi-sound-output-chooser"')
end
apps.mic_selector = function()
  awful.spawn.with_shell('rofi -show rofi-mic -modi "rofi-mic:rofi-sound-input-chooser"')
end
apps.discord = function()
  -- Run or raise Discord running in the browser, spawned with Chromium browser's app mode
  -- >> Ubuntu / Debian
  -- helpers.run_or_raise({instance = 'discordapp.com__channels_@me'}, false, "chromium-browser --app=\"https://discordapp.com/channels/@me\"")
  -- >> Arch
  helpers.run_or_raise(
    { instance = "discordapp.com__channels_@me" },
    false,
    'chromium --app="https://discordapp.com/channels/@me"'
  )

  -- Run or raise Discord app
  -- helpers.run_or_raise({class = 'discord'}, false, "discord")
end
apps.weechat = function()
  helpers.run_or_raise({ instance = "weechat" }, true, user.terminal .. " --class weechat -e weechat")
end
apps.mail = function()
  helpers.run_or_raise({ class = user.email_client_class }, false, user.email_client, { switchtotag = true })
end
apps.gimp = function()
  helpers.run_or_raise({ class = "Gimp" }, false, "gimp")
end
apps.steam = function()
  helpers.run_or_raise({ class = "Steam" }, false, "steam")
end
apps.lutris = function()
  helpers.run_or_raise({ class = "Lutris" }, false, "lutris")
end
apps.youtube = function()
  awful.spawn.with_shell("rofi_mpvtube")
end
apps.networks = function()
  awful.spawn.with_shell("rofi-network-manager")
end
apps.vpn = function()
  awful.spawn.with_shell("mozillavpn")
end
apps.toggle_vpn = function()
  local mozilla_script = [=[
    if [[ $(mozillavpn status | grep "VPN state: off") ]]; then
      if [[ $(mozillavpn activate) ]]; then
        awesome-client "awesome.emit_signal('evil::vpn::enabled')"
      fi
    else
      if [[ $(mozillavpn deactivate) ]]; then
        awesome-client "awesome.emit_signal('evil::vpn::disabled')"
      fi
    fi
  ]=]
  local tailscale_script = [=[
    if [[ $(tailscale status | grep "stopped") ]]; then
      if [[ $(tailscale )]]
  ]=]
  awful.spawn.with_shell(mozilla_script)
end
apps.passwords = function()
  helpers.run_or_raise({ class = "1password" }, true, "1password")
end
apps.volume = function()
  helpers.run_or_raise({ class = "Pavucontrol" }, true, "pavucontrol")
end
apps.torrent = function()
  helpers.run_or_raise({ instance = "torrent" }, true, user.terminal .. " --class torrent -e transmission-remote-cli")
end

apps.editor = function()
  helpers.run_or_raise({ instance = "editor" }, false, user.editor, { switchtotag = true })
end

-- Toggle compositor
apps.compositor = function()
  awful.spawn.with_shell(
    "sh -c 'pgrep picom > /dev/null && pkill picom || picom --config ~/.config/picom/picom.conf & disown'"
  )
end

local night_mode_notif
apps.night_mode = function()
  local cmd =
    "pgrep redshift > /dev/null && (pkill redshift && echo 'OFF') || (echo 'ON' && redshift -l 0:0 -t 3700:3700 -r &>/dev/null &)"
  awful.spawn.easy_async_with_shell(cmd, function(out)
    local message = out:match("ON") and "Activated!" or "Deactivated!"
    night_mode_notif = notifications.notify_dwim(
      { title = "Night mode", message = message, app_name = "night_mode", icon = icons.image.redshift },
      night_mode_notif
    )
  end)
end

local screenkey_notif
apps.screenkey = function()
  local cmd = "pgrep screenkey > /dev/null && (pkill screenkey && echo 'OFF') || (echo 'ON' && screenkey --ignore Caps_Lock --bg-color '"
    .. x.background
    .. "' --font-color '"
    .. x.color1
    .. "' &>/dev/null &)"
  awful.spawn.easy_async_with_shell(cmd, function(out)
    local message = out:match("ON") and "Activated!" or "Deactivated!"
    screenkey_notif = notifications.notify_dwim(
      { title = "Screenkey", message = message, app_name = "screenkey", icon = icons.image.keyboard },
      screenkey_notif
    )
  end)
end

apps.record = function()
  awful.spawn.with_shell("screenrec.sh")
end

-- I only use emacs for org mode :)
apps.org = function()
  helpers.run_or_raise({ class = "Emacs" }, false, "emacs")
end

apps.music = function()
  helpers.run_or_raise({ instance = "music" }, false, user.music_client, { switchtotag = true })
end

apps.visualizer = function()
  helpers.run_or_raise({ class = "Visualizer" }, false, user.visualizer, { switchtotag = true })
end

apps.process_monitor = function()
  helpers.run_or_raise({ instance = "htop" }, false, user.terminal .. " --class htop -e htop", { switchtotag = true })
end

apps.process_monitor_gui = function()
  helpers.run_or_raise({ class = "Lxtask" }, false, "lxtask")
end

apps.temperature_monitor = function()
  helpers.run_or_raise(
    { class = "sensors" },
    false,
    user.terminal .. " --class sensors -e watch sensors",
    { switchtotag = true, tag = mouse.screen.tags[5] }
  )
end

apps.battery_monitor = function()
  helpers.run_or_raise(
    { class = "battop" },
    false,
    user.terminal .. " --class battop -e battop",
    { switchtotag = true, tag = mouse.screen.tags[5] }
  )
end

apps.markdown_input = function()
  helpers.scratchpad(
    { instance = "markdown_input" },
    user.terminal .. " --class markdown_input -e nvim -c 'startinsert' /tmp/scratchpad.md",
    nil
  )
end

apps.todo_input = function()
  helpers.scratchpad(
    { instance = "todo_input" },
    user.terminal .. " --class todo_input -e nvim " .. user.dirs.home .. "/todo.txt",
    nil
  )
end

-- Scratchpad terminal with tmux (see bin/scratchpad)
apps.scratchpad = function()
  helpers.scratchpad({ instance = "scratchpad" }, "scratchpad", nil)
end

-- Screenshots
local capture_notif = nil
local screenshot_notification_app_name = "screenshot"
function apps.screenshot(action, delay)
  -- Read-only actions
  if action == "browse" then
    awful.spawn.with_shell("cd " .. user.dirs.screenshots .. " && nsxiv $(ls -t)")
    return
  elseif action == "gimp" then
    awful.spawn.with_shell("cd " .. user.dirs.screenshots .. " && gimp $(ls -t | head -n1)")
    naughty.notification({
      message = "Opening last screenshot with GIMP",
      icon = icon,
      app_name = screenshot_notification_app_name,
    })
    return
  end

  -- Screenshot capturing actions
  local cmd
  local timestamp = os.date("%Y.%m.%d-%H.%M.%S")
  local filename = user.dirs.screenshots .. "/" .. timestamp .. ".screenshot.png"
  local maim_args = "-u -b 3 -m 5"
  local icon = icons.image.screenshot

  local prefix
  if delay then
    prefix = "sleep " .. tostring(delay) .. " && "
  else
    prefix = ""
  end

  -- Configure action buttons for the notification
  local screenshot_open = naughty.action({ name = "Open" })
  local screenshot_copy = naughty.action({ name = "Copy" })
  local screenshot_edit = naughty.action({ name = "Edit" })
  local screenshot_delete = naughty.action({ name = "Delete" })
  screenshot_open:connect_signal("invoked", function()
    awful.spawn.with_shell("cd " .. user.dirs.screenshots .. " && nsxiv $(ls -t)")
  end)
  screenshot_copy:connect_signal("invoked", function()
    awful.spawn.with_shell("xclip -selection clipboard -t image/png " .. filename .. " &>/dev/null")
  end)
  screenshot_edit:connect_signal("invoked", function()
    awful.spawn.with_shell("gimp " .. filename .. " >/dev/null")
  end)
  screenshot_delete:connect_signal("invoked", function()
    awful.spawn.with_shell("rm " .. filename)
  end)

  if action == "full" then
    cmd = prefix .. "maim " .. maim_args .. " " .. filename
    awful.spawn.easy_async_with_shell(cmd, function()
      naughty.notification({
        title = "Screenshot",
        message = "Screenshot taken",
        icon = icon,
        actions = { screenshot_open, screenshot_copy, screenshot_edit, screenshot_delete },
        app_name = screenshot_notification_app_name,
      })
    end)
  elseif action == "selection" then
    cmd = "maim " .. maim_args .. " -s " .. filename
    capture_notif = naughty.notification({
      title = "Screenshot",
      message = "Select area to capture.",
      icon = icon,
      timeout = 1,
      app_name = screenshot_notification_app_name,
    })
    awful.spawn.easy_async_with_shell(cmd, function(_, __, ___, exit_code)
      naughty.destroy(capture_notif)
      if exit_code == 0 then
        naughty.notification({
          title = "Screenshot",
          message = "Selection captured",
          icon = icon,
          actions = { screenshot_open, screenshot_copy, screenshot_edit, screenshot_delete },
          app_name = screenshot_notification_app_name,
        })
      end
    end)
  elseif action == "clipboard" then
    capture_notif =
      naughty.notification({ title = "Screenshot", message = "Select area to copy to clipboard", icon = icon })
    cmd = "maim "
      .. maim_args
      .. " -s /tmp/maim_clipboard && xclip -selection clipboard -t image/png /tmp/maim_clipboard &>/dev/null && rm /tmp/maim_clipboard"
    awful.spawn.easy_async_with_shell(cmd, function(_, __, ___, exit_code)
      if exit_code == 0 then
        capture_notif = notifications.notify_dwim({
          title = "Screenshot",
          message = "Copied selection to clipboard",
          icon = icon,
          app_name = screenshot_notification_app_name,
        }, capture_notif)
      else
        naughty.destroy(capture_notif)
      end
    end)
  end
end

return apps
