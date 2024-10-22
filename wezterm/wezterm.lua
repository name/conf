local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'Berkeley Mono'
config.color_scheme = 'flexoki-dark'
-- config.window_background_image = 'C:\\Users\\cmaddex\\OneDrive - SNC Ltd\\Pictures\\wallpapers\\2.jpg'
-- config.window_background_image_hsb = {
--   -- Darken the background image by reducing it to 1/3rd
--   brightness = 0.025,

--   -- You can adjust the hue by scaling its value.
--   -- a multiplier of 1.0 leaves the value unchanged.
--   hue = 1.0,

--   -- You can adjust the saturation also.
--   saturation = 1.0,
-- }

config.default_prog = { 'powershell.exe', '-NoLogo' }

return config
