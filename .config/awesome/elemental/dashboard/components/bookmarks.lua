local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")
local naughty = require("naughty")

local temp_file = "/tmp/awesome-evil-git-repos"
local update_interval = 15 * 60 -- 15 minutes

local function create_web_bookmark(name, url, color, hover_color)
  local bookmark = wibox.widget.textbox()
  bookmark.font = "sans bold 16"
  -- bookmark.text = wibox.widget.textbox(name:sub(1,1):upper()..name:sub(2))
  bookmark.markup = helpers.colorize_text(name, color)
  bookmark.align = "center"
  bookmark.valign = "center"

  -- Buttons
  bookmark:buttons(gears.table.join(awful.button({}, 1, function()
    awful.spawn.with_shell(user.browser .. " " .. url)
    dashboard_hide()
  end)))

  -- Hover effect
  bookmark:connect_signal("mouse::enter", function()
    bookmark.markup = helpers.colorize_text(name, hover_color)
  end)
  bookmark:connect_signal("mouse::leave", function()
    bookmark.markup = helpers.colorize_text(name, color)
  end)

  helpers.add_hover_cursor(bookmark, "hand1")

  return bookmark
end

local function create_bookmark(name, path, color, hover_color)
  local bookmark = wibox.widget.textbox()
  bookmark.font = "sans bold 16"
  -- bookmark.text = wibox.widget.textbox(name:sub(1,1):upper()..name:sub(2))
  bookmark.markup = helpers.colorize_text(name, color)
  bookmark.align = "center"
  bookmark.valign = "center"

  -- Buttons
  bookmark:buttons(gears.table.join(
    awful.button({}, 1, function()
      awful.spawn.with_shell(user.file_manager .. " " .. path)
      dashboard_hide()
    end),
    awful.button({}, 3, function()
      awful.spawn.with_shell(user.terminal .. " -e 'ranger' " .. path)
      dashboard_hide()
    end)
  ))

  -- Hover effect
  bookmark:connect_signal("mouse::enter", function()
    bookmark.markup = helpers.colorize_text(name, hover_color)
  end)
  bookmark:connect_signal("mouse::leave", function()
    bookmark.markup = helpers.colorize_text(name, color)
  end)

  helpers.add_hover_cursor(bookmark, "hand1")

  return bookmark
end

-- local bookmarks = wibox.widget {
-- spacing = dpi(15),
-- layout = wibox.layout.fixed.vertical
-- }

-- function update_git_repos(git_output)
-- for i,w in pairs(bookmarks:get_all_children()) do
-- bookmarks:remove_widgets(w)
-- end
-- end

awesome.connect_signal("evil::git_repos", function(git_repos)
  -- Do something with git repos
end)

local bookmarks = wibox.widget({
  create_web_bookmark("trello", "https://trello.com/jonathandexter4/boards", x.color1, x.color9),
  create_web_bookmark("kumai", "https://kimai.monkeyjumplabs.com", x.color2, x.color10),
  create_web_bookmark("node-red", "https://node-red.monkeyjumplabs.com/ui", x.color6, x.color14),
  create_web_bookmark("hubspot", "https://app.hubspot.com", x.color4, x.color12),
  create_web_bookmark("quickbooks", "https://app.qbo.intuit.com/app", x.color5, x.color13),
  --create_bookmark("home", os.getenv("HOME"), x.color1, x.color9),
  --create_bookmark("downloads", user.dirs.downloads, x.color2, x.color10),
  --create_bookmark("music", user.dirs.music, x.color6, x.color14),
  --create_bookmark("pictures", user.dirs.pictures, x.color4, x.color12),
  --create_bookmark("wallpapers", user.dirs.wallpapers, x.color5, x.color13),
  --create_bookmark("screenshots", user.dirs.screenshots, x.color3, x.color11),
  margins = dpi(30),
  spacing = dpi(15),
  layout = wibox.layout.fixed.vertical,
})

local refresh_button = wibox.widget({
  {
    {
      {
        markup = "Refresh",
        align = "center",
        valign = "center",
        font = "Sans Bold 16",
        widget = wibox.widget.textbox,
      },
      top = box_gap * 2,
      bottom = box_gap * 2,
      widget = wibox.container.margin,
    },
    align = "center",
    valign = "center",
    bg = x.color3,
    shape = helpers.rrect(dpi(6)),
    widget = wibox.container.background,
  },
  left = box_gap * 3,
  right = box_gap * 3,
  bottom = box_gap,
  top = box_gap,
  widget = wibox.container.margin,
})
helpers.add_hover_cursor(refresh_button, "hand1")
refresh_button:buttons(gears.table.join(awful.button({}, 1, function()
  awesome.emit_signal('evil::github::pr::refresh')
end)))

awesome.connect_signal("evil::github::pr", function(prs)
  if prs then
    for i, w in pairs(bookmarks:get_all_children()) do
      bookmarks:remove_widgets(w)
    end
    local count = 0
    for i, pr in pairs(prs) do
      count = count + 1
      bookmarks:add(create_web_bookmark(pr.title, pr.url, x["color" .. i], x["color" .. (i + 8)]))
    end
    if count == 0 then
      -- No PRs, show something nice
      bookmarks:add(create_web_bookmark("🎉", "", x["color0"], x["color8"]))
      bookmarks:add(create_web_bookmark("All done!", "", x["color1"], x["color9"]))
    end
  end
end)

-- Pull into evil/git-repos.lua
local function update_git_repos(stdout)
  awesome.emit_signal("evil::git_repos", stdout)
end

local src_dir = os.getenv("SRC")
local rg_cmd = "rg --files --hidden --no-messages -g HEAD " .. src_dir .. " | rg .git.HEAD | sed -E s/..git.HEAD$//"
helpers.remote_watch(rg_cmd, update_interval, temp_file, update_git_repos)
-- End pull

local align_layout = wibox.layout.align.vertical({
})
align_layout.forced_height = dpi(396)
align_layout:set_top(bookmarks)
align_layout:set_bottom(refresh_button)

return align_layout
