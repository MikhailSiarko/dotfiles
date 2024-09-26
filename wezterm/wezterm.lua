local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font('FiraCode Nerd Font Mono', { weight = 'Medium' })
config.font_size = 14.0
config.initial_rows = 40
config.initial_cols = 160

config.window_close_confirmation = 'NeverPrompt'
config.hide_tab_bar_if_only_one_tab = true
config.hide_mouse_cursor_when_typing = true
config.tab_bar_at_bottom = true

config.color_scheme = 'Dark+'

config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7,
}

config.leader = { key = 'a', mods = 'CMD', timeout_milliseconds = 1000 }
config.keys = {
    {
        key = '|',
        mods = 'LEADER|SHIFT',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = '-',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },

    {
        key = 'w',
        mods = 'CTRL',
        action = wezterm.action.CloseCurrentPane { confirm = false, domain = 'CurrentTanDomain' },
    },
}

return config
