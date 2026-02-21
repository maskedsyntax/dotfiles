-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = {}

-- or, changing the font size and color scheme.
config.font_size = 11
config.font = wezterm.font 'MonoLisa'
-- config.font = wezterm.font 'Cascadia Code'
-- config.color_scheme = 'GruvboxDarkHard'

config.window_background_opacity = 0.9
config.tab_bar_at_bottom = true

-- Keybindings for splitting panes
config.keys = {
  -- Split horizontally (side-by-side)
  {
    key = "RightArrow",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  {
    key = "LeftArrow",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },

  -- Split vertically (top/bottom)
  {
    key = "DownArrow",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },
  {
    key = "UpArrow",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },
}

-- Finally, return the configuration to wezterm:
return config
