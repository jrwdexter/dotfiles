local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local icons = require("icons")
local helpers = require("helpers")
local apps = require("apps")
local json = require("json")
local htmlEntities = require("htmlEntities")
local constants = require("elemental.dashboard.amarena.constants")

box_radius = constants.box_radius
box_gap = constants.box_gap
screen_width = constants.screen_width
screen_height = constants.screen_height

local keygrabber = require("awful.keygrabber")

-- Create the widget

dashboard = wibox({visible = false, ontop = true, type = "dock", screen = screen.primary})
awful.placement.maximize(dashboard)

dashboard.bg = beautiful.dashboard_bg or beautiful.exit_screen_bg or beautiful.wibar_bg or "#111111"
dashboard.fg = beautiful.dashboard_fg or beautiful.exit_screen_fg or beautiful.wibar_fg or "#FEFEFE"

-- Add dashboard or mask to each screen
for s in screen do
    if s == screen.primary then
        s.dashboard = dashboard
    else
        s.dashboard = helpers.screen_mask(s, dashboard.bg)
    end
end

local function set_visibility(v)
    for s in screen do
        s.dashboard.visible = v
    end
end

dashboard:buttons(gears.table.join(
    -- Middle click - Hide dashboard
    awful.button({ }, 2, function ()
        dashboard_hide()
    end)
))

-- Helper function that puts a widget inside a box with a specified background color
-- Invisible margins are added so that the boxes created with this function are evenly separated
-- The widget_to_be_boxed is vertically and horizontally centered inside the box
local function create_boxed_widget(widget_to_be_boxed, width, height, bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(box_radius)
    -- box_container.shape = helpers.prrect(20, true, true, true, true)
    -- box_container.shape = helpers.prrect(30, true, true, false, true)

    local boxed_widget = wibox.widget {
        -- Add margins
        {
            -- Add background color
            {
                -- Center widget_to_be_boxed horizontally
                nil,
                {
                    -- Center widget_to_be_boxed vertically
                    nil,
                    -- The actual widget goes here
                    widget_to_be_boxed,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                layout = wibox.layout.align.horizontal,
                expand = "none"
            },
            widget = box_container,
        },
        margins = box_gap,
        color = "#FF000000",
        widget = wibox.container.margin
    }

    return boxed_widget
end

----------------------------------
------------- WIDGETS ------------
----------------------------------

-- User Widget

local user_widget = require('elemental.dashboard.components.user')
local user_box = create_boxed_widget(user_widget, dpi(450), dpi(510), x.background)

-- Fortune

local fortune_widget = require("elemental.dashboard.components.fortune")
local fortune_box = create_boxed_widget(fortune_widget, dpi(450), dpi(210), x.background)

-- URL launcher petals

local url_petals = require("elemental.dashboard.components.petals")
local url_petals_box = create_boxed_widget(url_petals, dpi(225), dpi(225), "#00000000")

-- Agenda

local agenda = require("elemental.dashboard.components.agenda")
local calendar_box = create_boxed_widget(agenda, dpi(450), dpi(600), x.background)

-- Disk arc

local disk = require("elemental.dashboard.components.disk")
local disk_box = create_boxed_widget(disk, dpi(225), dpi(225), x.background)

-- File system bookmarks

local bookmarks = require("elemental.dashboard.components.bookmarks")
local bookmarks_box = create_boxed_widget(bookmarks, dpi(300), dpi(450), x.background)

-- Corona

local corona = require("elemental.dashboard.components.corona")
local corona_box = create_boxed_widget(corona, dpi(300), dpi(270), x.background)

-- Uptime

local uptime = require("elemental.dashboard.components.uptime")
local uptime_box = create_boxed_widget(uptime, dpi(450), dpi(120), x.background)

uptime_box:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        exit_screen_show()
        gears.timer.delayed_call(function()
            dashboard_hide()
        end)
    end)
))
helpers.add_hover_cursor(uptime_box, "hand1")

-- Mute notification widget

local notification = require("elemental.dashboard.components.notification")
local notification_state = notification.widget
local notification_state_box = create_boxed_widget(notification_state, dpi(225), dpi(117), x.background)

notification_state_box:buttons(gears.table.join(
    -- Left click - Toggle notification state
    awful.button({ }, 1, function ()
        naughty.suspended = not naughty.suspended
        notification.update()
    end)
))

helpers.add_hover_cursor(notification_state_box, "hand1")

-- Screenshot widget

local screenshot = require("elemental.dashboard.components.screenshot")
local screenshot_box = create_boxed_widget(screenshot, dpi(225), dpi(117), x.background)
screenshot_box:buttons(gears.table.join(
    -- Left click - Take screenshot
    awful.button({ }, 1, function ()
        apps.screenshot("full")
    end),
    -- Right click - Take screenshot in 5 seconds
    awful.button({ }, 3, function ()
        naughty.notify({title = "Say cheese!", text = "Taking shot in 5 seconds", timeout = 4, icon = icons.image.screenshot})
        apps.screenshot("full", 5)
    end)
))

helpers.add_hover_cursor(screenshot_box, "hand1")

----------------------------------
-------- DASHBOARD LAYOUT --------
----------------------------------

-- Item placement

dashboard:setup {
    -- Center boxes vertically
    nil,
    {
        -- Center boxes horizontally
        nil,
        {
            -- Column container
            {
                -- Column 1
                user_box,
                fortune_box,
                layout = wibox.layout.fixed.vertical
            },
            {
                -- Column 2
                url_petals_box,
                notification_state_box,
                screenshot_box,
                disk_box,
                layout = wibox.layout.fixed.vertical
            },
            {
                -- Column 3
                bookmarks_box,
                corona_box,
                layout = wibox.layout.fixed.vertical
            },
            {
                -- Column 4
                calendar_box,
                uptime_box,
                layout = wibox.layout.fixed.vertical
            },
            layout = wibox.layout.fixed.horizontal
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal

    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}

local dashboard_grabber
function dashboard_hide()
    awful.keygrabber.stop(dashboard_grabber)
    set_visibility(false)
end


local original_cursor = "left_ptr"
function dashboard_show()
    -- Fix cursor sometimes turning into "hand1" right after showing the dashboard
    -- Sigh... This fix does not always work
    local w = mouse.current_wibox
    if w then
        w.cursor = original_cursor
    end
    -- naughty.notify({text = "starting the keygrabber"})
    dashboard_grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        -- Press Escape or q or F1 to hide it
        if key == 'Escape' or key == 'q' or key == 'F1' then
            dashboard_hide()
        end
    end)
    set_visibility(true)
end
