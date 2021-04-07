local gfs = require("gears.filesystem")
local base = dofile(string.format("%sthemes/%s/theme.lua", gfs.get_configuration_dir(), "default"))

base.wallpaper = string.format("%s/Pictures/%s", os.getenv("HOME"), "ATLA/ATLA_EK_HD.png")

return base;
