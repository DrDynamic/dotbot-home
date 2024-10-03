-- Pull in the wezterm API
local wezterm = require 'wezterm'
local titlebar = require 'titlebar.titlebar'

-- This will hold the configuration.
local config = wezterm.config_builder()
config.font = wezterm.font("MesloLGS NF")
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
--  font=wezterm.font({family = 'JetBrains Mono', weight='Bold'}),
    font=wezterm.font({family = 'Berkeley Mono', weight='Bold'}),
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

wezterm.on('update-status', function(window)
  -- Grab the utf8 character for the "powerline" left facing
  -- solid arrow.
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  local segments = segments_for_right_status(window)

  -- Grab the current window's configuration, and from it the
  -- palette (this is the combination of your chosen colour scheme
  -- including any overrides).
  local color_scheme = window:effective_config().resolved_palette
  local bg = wezterm.color.parse(color_scheme.background)
  local fg = color_scheme.foreground

  local gradient_to, gradient_from = bg
  gradient_from = gradient_to:lighten(0.2)

  local gradient = wezterm.color.gradient(
    {
      orientation = 'Horizontal',
      colors = { gradient_from, gradient_to },
    },
    #segments -- only gives us as many colours as we have segments.
  )

  local elements = {}

  for i, seg in ipairs(segments) do
    local is_first = i == 1

    if is_first then
      table.insert(elements, { Background = { Color = 'none' } })
    end
    table.insert(elements, { Foreground = { Color = gradient[i] } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })

    table.insert(elements, { Foreground = { Color = fg } })
    table.insert(elements, { Background = { Color = gradient[i] } })
    table.insert(elements, { Text = ' ' .. seg .. ' ' })
  end
  
  table.insert(elements, { Foreground = { Color = '#2c2c2c' } })
  table.insert(elements, { Text = SOLID_LEFT_ARROW })
  
  window:set_right_status(wezterm.format(elements))
end)

-- and finally, return the configuration to wezterm
return config
