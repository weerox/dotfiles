local wl = require("wibox.layout")
local ww = require("wibox.widget")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local function new()
	print("start microphone")
	local w = wl.fixed.horizontal()
	local w_icon = ww.imagebox()
	local w_text = ww.textbox()

	w:set_spacing(5)

	local function widget_update(microphone_volume, microphone_muted)
		local icon = os.getenv("HOME") .. "/.config/awesome/widgets/microphone/icons/microphone_volume-"
		local text = nil

		if microphone_volume ~= nil then
			text = microphone_volume .. "%"

			if microphone_volume >= 66 then
				icon = icon .. "3"
			elseif microphone_volume >= 33 then
				icon = icon .. "2"
			else
				icon = icon .. "1"
			end

			if microphone_muted then
				icon = icon .. "-off"
			end

			icon = icon .. ".png"

			print(icon)

			w_icon:set_image(gears.color.recolor_image(icon, beautiful.wibar.widgets.icon_color))
--			w_icon:set_image(gears.color.recolor_image(icon, "#ffffff"))
			w_text:set_text(text)
		end
	end

	local function microphone_update()
		awful.spawn.easy_async_with_shell([[pactl list sources | awk -v D="$(pactl info | grep "Default Source:" | awk '{ print $3 }')" -v RS='' '/D/' | grep "Volume:" | grep -o "[0-9]*%" | head -n1 | sed 's/%$//']], function (stdout)
			local microphone_volume = tonumber(stdout)

			awful.spawn.easy_async_with_shell([[pactl list sources | awk -v RS='' "/Name: $(pactl info | grep "Default Source:" | awk '{ print $3 }')/" | grep "Mute:" | awk '{ $1=$1; print $2 }']], function (stdout)
				local microphone_muted = true
				if string.gsub(stdout, "(.-)%s*$", "%1") == "no" then
					microphone_muted = false
				end

				widget_update(microphone_volume, microphone_muted)
			end)
		end)
	end

	microphone_update()

	-- FIXME: this probably doesn't need to be a timer
	-- after we can change volume with widget
	local timer = gears.timer.start_new(10, function() microphone_update() return true end)

	w:add(w_icon)
	w:add(w_text)

	print("end microphone")
	return w
end

return new()
