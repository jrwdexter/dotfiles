local calendar = require("noodle.calendar")

-- Update calendar whenever dashboard is shown
dashboard:connect_signal("property::visible", function ()
    if dashboard.visible then
        calendar.date = os.date('*t')
    end
end)

return calendar
