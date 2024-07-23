local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("MonaspiceNe NFM")
config.font_size = 14

config.window_background_opacity = 0.8
config.color_scheme = 'nightfox'
return config