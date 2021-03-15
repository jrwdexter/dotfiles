local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require ("helpers")
local htmlEntities = require("htmlEntities")

local function create_link(start_date, end_date, name, link) 
    local color = x.color3
    local hover_color = x.color9
    local date_line = wibox.widget.textbox()
    date_line.margin = box_gap
    date_line.font = "sans bold 12"

    start_year, start_month, start_day, start_hour, start_min, start_second = helpers.parse_date(start_date)
    end_year, end_month, end_day, end_hour, end_min, end_second = helpers.parse_date(end_date)
    local date_line_text = "["..start_hour..":"..start_min.." - "..end_hour..":"..end_min.."]"
    date_line.markup = helpers.colorize_text(date_line_text, color)
    -- Set font size, color, content, and click
    -- Ideally, change color based on type of event or something
    -- Like red = conflict
    local description_line = wibox.widget.textbox()
    description_line.margin = box_gap
    description_line.font = "sans italic 10"
    description_line.markup = helpers.colorize_text(name, color)

    local agenda_line = wibox.widget {
      date_line,
      description_line,
      layout = wibox.layout.fixed.vertical,
      top = box_gap,
      bottom = box_gap
    }

    agenda_line:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            awful.spawn(user.browser.." "..link)
            dashboard_hide()
        end),
        awful.button({ }, 3, function ()
            awful.spawn(user.browser.." "..link)
            dashboard_hide()
        end)
    ))

    helpers.add_hover_cursor(agenda_line, "hand1")

    agenda_line:connect_signal("mouse::enter", function()
        date_line.markup = helpers.colorize_text(date_line_text, hover_color)
        description_line.markup = helpers.colorize_text(name, hover_color)
    end)

    agenda_line:connect_signal("mouse::leave", function()
        date_line.markup = helpers.colorize_text(date_line_text, color)
        description_line.markup = helpers.colorize_text(name, color)
    end)

    return agenda_line
end

local agenda_links = wibox.widget {
  spacing = dpi(15),
  layout = wibox.layout.fixed.vertical
}

function create_agenda_links(calendar_output)
  -- Clear existing links
  for i,w in pairs(agenda_links:get_all_children()) do
    agenda_links:remove_widgets(w)
  end

  -- Add new links
  for key, value in pairs(calendar_output) do
    if (key > 8) then
      return
    end
    agenda_links:add(create_link(
      (value.start_date),
      (value.end_date),
      htmlEntities.encode(value.description),
      value.video or value.link))
  end
end

local agenda = wibox.widget {
  {
    {
      {
          align = "center",
          valign = "top",
          font = "Sans bold 20",
          markup = helpers.colorize_text("Agenda", x.color2),
          widget = wibox.widget.textbox()
      },
      {
        align = "center",
        valign = "top",
        font = "sans italic 12",
        markup = helpers.colorize_text("jdexter@nerdery.com", x.color2),
        widget = wibox.widget.textbox()
      },
      layout = wibox.layout.fixed.vertical
    },
    wibox.widget {
      agenda_links,
      align = "left",
      widget = wibox.layout.fixed.vertical
    },
    spacing = dpi(30),
    layout = wibox.layout.fixed.vertical
  },
  widget = wibox.container.margin,
  margins = box_gap,
  top = box_gap,
  bottom = box_gap,

}

awesome.connect_signal("evil::gcal", function(calendar_output)
    local links = {}
    create_agenda_links(calendar_output)
    -- Do something with the calendar_output table object
    -- corona_cases.markup = cases_total.." <i>(+"..cases_today..")</i>"
    -- corona_deaths.markup = deaths_total.." <i>(+"..deaths_today..")</i>"
end)

return agenda
