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

	local function widget_update(speaker_volume, speaker_muted)
		local icon = os.getenv("HOME") .. "/.config/awesome/widgets/speaker/icons/speaker_volume-"
		local text = nil

		if speaker_volume ~= nil then
			text = speaker_volume .. "%"

			if speaker_volume >= 66 then
				icon = icon .. "3"
			elseif speaker_volume >= 33 then
				icon = icon .. "2"
			else
				icon = icon .. "1"
			end

			if speaker_muted then
				icon = icon .. "-off"
			end

			icon = icon .. ".png"

			w_icon:set_image(gears.color.recolor_image(icon, beautiful.wibar.widgets.icon_color))
--			w_icon:set_image(gears.color.recolor_image(icon, "#ffffff"))
			w_text:set_text(text)
		end
	end

	local function speaker_update()
		awful.spawn.easy_async_with_shell([[pactl get-sink-volume $(pactl get-default-sink) | grep -o "[0-9]*%" | head -n1 | sed 's/%$//']], function (stdout)
			local speaker_volume = tonumber(stdout)

			awful.spawn.easy_async_with_shell([[pactl get-sink-mute $(pactl get-default-sink) | awk '{ $1=$1; print $2 }']], function (stdout)
				local speaker_muted = true
				if string.gsub(stdout, "(.-)%s*$", "%1") == "no" then
					speaker_muted = false
				end

				widget_update(speaker_volume, speaker_muted)
			end)
		end)
	end

	speaker_update()

	-- FIXME: this probably doesn't need to be a timer
	-- after we can change volume with widget
	local timer = gears.timer.start_new(10, function() speaker_update() return true end)

	w:add(w_icon)
	w:add(w_text)

	return w
end

return new()
