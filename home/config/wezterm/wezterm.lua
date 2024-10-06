-- Pull in the wezterm API
local wezterm = require 'wezterm'
local titlebar = require 'titlebar/titlebar'
local status_git = require 'titlebar/status_git'
local status_uptime = require 'titlebar/status_uptime'
local status_apt = require 'titlebar/status_apt'
local status_flatpak = require 'titlebar/status_flatpak'
local status_snap = require 'titlebar/status_snap'

-- This will hold the configuration.
local config = wezterm.config_builder()
config.font = wezterm.font("MesloLGS Nerd Font")
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Afterglow'
--config.color_scheme = 'Andromeda'
--config.color_scheme='Catppuccin Mocha'
--config.color_scheme='JetBrains Darcula'
config.color_scheme= 'Tokyo Night'

config.audible_bell="Disabled"
config.enable_wayland=true
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.initial_cols=145
config.initial_rows=35
config.window_frame = {
  font=wezterm.font({family = 'MesloLGS Nerd Font', weight='Bold'}),
--    font=wezterm.font({family = 'Berkeley Mono', weight='Bold'}),
    font_size=11,
    inactive_titlebar_bg='#2c2c2c',
    active_titlebar_bg='#272727',
    border_left_width = 1,
    border_right_width = 1,
    border_bottom_height = 1,
    border_top_height = 1,
    border_left_color = '#414141',
    border_right_color = '#414141',
    border_bottom_color = '#414141',
    border_top_color = '#616161',
}

config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }

config.window_padding={
    left=2,
    right=2,
    top=2,
    bottom=2
}

config.background = {
  {
    source = {
      File = wezterm.config_dir .. '/test.png',
    },
    height=135,
    width=135,
    repeat_x = "Mirror",
    repeat_y = "Mirror",
    hsb = {brightness = 0.1},
    opacity = 0.9,
  },
}


-- from: https://alexplescan.com/posts/2024/08/10/wezterm/
local function segments_for_right_status(window)
  return {
    window:active_workspace(),
    wezterm.strftime('%a %b %-d %H:%M'),
    wezterm.hostname(),
  }
end

titlebar.set_seperator(titlebar.SOLID_LEFT_ARROW, titlebar.SOLID_LEFT_ARROW_DIVIDER)
titlebar.add_right_status(status_apt.new())
titlebar.add_right_status(status_flatpak.new())
titlebar.add_right_status(status_snap.new())
titlebar.add_right_status(status_uptime.new())
titlebar.add_right_status(status_git.new('config', '~/.config/dotbot'))


-- and finally, return the configuration to wezterm
return config
