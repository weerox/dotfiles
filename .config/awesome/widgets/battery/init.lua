local wl = require("wibox.layout")
local ww = require("wibox.widget")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local function new()
	local w = wl.fixed.horizontal()
	local w_icon = ww.imagebox()
	local w_text = ww.textbox()

	w:set_spacing(5)

	local function widget_update(bat_percentage, bat_status)
		-- FIXME: use gears.filesystem here
		local icon = os.getenv("HOME") .. "/.config/awesome/widgets/battery/icons/battery_"
		local text = nil

		icon = icon .. "percentage-"

		if bat_percentage ~= nil then
			text = bat_percentage .. "%"

			if bat_percentage == 100 then
				icon = icon .. "100"
			else 
				icon = icon .. ((bat_percentage // 10) * 10)
			end
		end

		if bat_status == "Charging" then
			icon = icon .. "-charging"
		end

		icon = icon .. ".png"

		local color = beautiful.wibar.widgets.icon_color
		if bat_percentage == 100 and bat_status == "Charging" then
			color = "#2dc254"
		elseif bat_percentage < 10 and bat_status ~= "Charging" then
			color = "#c22d2d"
		end
		w_icon:set_image(gears.color.recolor_image(icon, color))
--		w_icon:set_image(gears.color.recolor_image(icon, "#ffffff"))
		w_text:set_text(text)
	end

	local function bat_update()
		awful.spawn.easy_async_with_shell([[cat /sys/class/power_supply/BAT0/capacity]], function (stdout)
			local bat_percentage = tonumber(stdout)
			awful.spawn.easy_async_with_shell([[cat /sys/class/power_supply/BAT0/status]], function (stdout) 
				local bat_status = string.gsub(stdout, "(.-)%s*$", "%1")

				widget_update(bat_percentage, bat_status)
			end)
		end)
	end

	-- FIXME: it would be nice to have the correct icon immediately at startup,
	-- maybe set initial timer to 1s and then change it to 10s?
	bat_update()

	local timer = gears.timer.start_new(10, function() bat_update() return true end)

	w:add(w_icon)
	w:add(w_text)

	return w;
end

return new()
