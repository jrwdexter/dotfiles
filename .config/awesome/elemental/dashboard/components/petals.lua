local awful   = require("awful")
local gears   = require("gears")
local helpers = require("helpers")
local wibox   = require("wibox")

local petal_font = "Sans Bold 16"

local function create_widget_petal(widget, bg_color, hover_color, url, tl, tr, br, bl)
    local petal_container = wibox.widget {
        bg = bg_color,
        forced_height = dpi(98),
        forced_width = dpi(98),
        shape = helpers.prrect(99, tl, tr, br, bl),
        widget = wibox.container.background()
    } 

    local petal = wibox.widget {
        {
            widget,
            widget = petal_container
        },
        -- Put the petal container inside a rounded container. Why?
        -- Because I want the unrounded petal corner to not be pointy!
        shape = helpers.rrect(dpi(6)),
        widget = wibox.container.background()
    }

    petal:buttons(
        gears.table.join(
            awful.button({ }, 1, function ()
                awful.spawn(user.browser.." "..url)
                dashboard_hide()
            end),
            awful.button({ }, 3, function ()
                awful.spawn(user.browser.." -new-window "..url, { switch_to_tags = true })
                dashboard_hide()
            end)
    ))

    petal:connect_signal("mouse::enter", function ()
        petal_container.bg = hover_color
    end)
    petal:connect_signal("mouse::leave", function ()
        petal_container.bg = bg_color
    end)

    return petal
end

local function create_text_petal(text, bg_color, hover_color, url, tl, tr, br, bl)
  local widget = {
    font = petal_font,
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox(text)
  }

  return create_widget_petal(widget, bg_color, hover_color, url, tl, tr, br, bl)
end

local function create_icon_petal(icon_name, bg_color, hover_color, url, tl, tr, br, bl)
  local container = wibox.container.background()
  container.shape = helpers.prrect(dpi(10), false, false, false, false)
  container.forced_height = dpi(10)
  container.forced_width = dpi(10)
  -- local widget = wibox.widget {
    -- {
      -- wibox.widget.imagebox(os.getenv("HOME").."/.config/awesome/icons/apps/"..icon_name),
      -- widget = container
    -- },
    -- shape = helpers.rrect(box_radius / 8),
    -- widget = wibox.container.background()
  -- }
  local widget = wibox.widget {
    {
      image = os.getenv("HOME").."/.config/awesome/icons/apps/"..icon_name,
      forced_height = 10,
      forced_width = 10,
      resize = true,
      widget = wibox.widget.imagebox
    },
    margins = box_gap * 3,
    widget = wibox.container.margin
  }
  return create_widget_petal(widget, bg_color, hover_color, url, tl, tr, br, bl)
end

-- Create the containers
local petal_top_left = create_icon_petal("google_drive_2020.png", x.color3, x.color11, "https://drive.google.com/", true, true, false, true)
local petal_top_right = create_icon_petal("google_mail_2020.png", x.color2, x.color10, "https://mail.google.com/", true, true, true, false)
local petal_bottom_right = create_text_petal("OA", x.color4, x.color12, "https://nerdery.app.openair.com/dashboard.pl?uid=QNJJUcTE6hGAWzIVeI6Jhw;app=ma;action=paint;_dashboard_layout=text;r=8kA6YAq8165",false, true, true, true)
local petal_bottom_left = create_text_petal("UP", x.color1, x.color9, "https://ultipro.nerdery.com/", true, false, true, true)

-- Add clickable effects on hover
helpers.add_hover_cursor(petal_top_left, "hand1")
helpers.add_hover_cursor(petal_top_right, "hand1")
helpers.add_hover_cursor(petal_bottom_left, "hand1")
helpers.add_hover_cursor(petal_bottom_right, "hand1")

local url_petals = wibox.widget {
    petal_top_left,
    petal_top_right,
    petal_bottom_left,
    petal_bottom_right,
    forced_num_cols = 2,
    spacing = box_gap * 2,
    layout = wibox.layout.grid
}

return url_petals
