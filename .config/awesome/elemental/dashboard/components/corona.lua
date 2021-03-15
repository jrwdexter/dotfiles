local awful   = require("awful")
local helpers = require("helpers")
local gears   = require("gears")
local wibox   = require("wibox")

local corona_cases = wibox.widget.textbox()
local corona_deaths = wibox.widget.textbox()
local corona = wibox.widget {
    {
        align = "center",
        valign = "center",
        font = "Sans bold 20",
        markup = helpers.colorize_text("Pandemic", x.color2),
        widget = wibox.widget.textbox()
    },
    {
        {
            align = "center",
            valign = "center",
            font = "icomoon 20",
            markup = helpers.colorize_text("", x.color3),
            widget = wibox.widget.textbox()
        },
        {
            align = "center",
            valign = "center",
            font = "sans medium 14",
            widget = corona_cases
        },
        spacing = dpi(9),
        layout = wibox.layout.fixed.horizontal
    },
    {
        {
            align = "center",
            valign = "center",
            font = "icomoon 20",
            markup = helpers.colorize_text("", x.color1),
            widget = wibox.widget.textbox()
        },
        {
            align = "center",
            valign = "center",
            font = "sans medium 14",
            widget = corona_deaths
        },
        spacing = dpi(9),
        layout = wibox.layout.fixed.horizontal
    },
    spacing = dpi(30),
    layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("evil::coronavirus", function(cases_total, cases_today, deaths_total, deaths_today)
    corona_cases.markup = cases_total.." <i>(+"..cases_today..")</i>"
    corona_deaths.markup = deaths_total.." <i>(+"..deaths_today..")</i>"
end)

corona:buttons(gears.table.join(
    -- Left click - Go to a more detailed website
    awful.button({ }, 1, function ()
        awful.spawn.with_shell(user.browser.." https://www.worldometers.info/coronavirus/")
        dashboard_hide()
    end)
))

helpers.add_hover_cursor(corona, "hand1")

return corona
