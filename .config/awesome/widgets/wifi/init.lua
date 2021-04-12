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

	local function widget_update(net_name, net_strength)
		-- FIXME: use gears.filesystem here
		local icon = os.getenv("HOME") .. "/.config/awesome/widgets/wifi/icons/wifi_"
		local text = "No connection"

		if net_name ~= nil and net_name ~= "" then
			text = net_name
			local signal = 1

			if net_strength ~= nil then
				if net_strength >= -6000 then
					signal = 4
				elseif net_strength >= -6700 then
					signal = 3
				elseif net_strength >= -7500 then
					signal = 2
				end
			end

			icon = icon .. "signal-" .. signal
		else
			icon = icon .. "no-connection"
		end

		icon = icon .. ".png"

		w_icon:set_image(gears.color.recolor_image(icon, beautiful.wibar.widgets.icon_color))
--		w_icon:set_image(gears.color.recolor_image(icon, "#ffffff"))
		w_text:set_text(text)
	end

	local function net_update()
		-- FIXME: make sure to do a scan to update the signal strength
		awful.spawn.easy_async_with_shell([[iwctl station wlan0 get-networks rssi-dbms | sed 's/\x1b\[[0-9;]*m//g' | sed 's/^ *//g' | grep -E '^>' | awk 'BEGIN{ORS=""}{print $2}']], function (stdout)
			-- when spawn reads stdout it adds a newline, so we have to remove it
			local net_name = string.gsub(stdout, "(.-)%s*$", "%1")

			awful.spawn.easy_async_with_shell([[iwctl station wlan0 get-networks rssi-dbms | sed 's/\x1b\[[0-9;]*m//g' | sed 's/^ *//g' | grep -E '^>' | awk '{print $4}']], function (stdout)
				local net_strength = tonumber(stdout)
				widget_update(net_name, net_strength)
			end)
		end)

		-- the network strength is only updated after a scan
		-- since we don't know how long a scan will take, we run it last and display the result at the next timer update
		awful.spawn.easy_async_with_shell([[iwctl station wlan0 scan]], function () end)

	end

	-- FIXME: it would be nice to have the correct icon immediately at startup,
	-- maybe set initial timer to 1s and then change it to 10s?
	net_update()

	local timer = gears.timer.start_new(10, function() net_update() return true end)

	w:add(w_icon)
	w:add(w_text)

	return w;
end

return new()
