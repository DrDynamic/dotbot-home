
local wezterm = require "wezterm"

local status_right = {}
local seperator = '|'

function set_seperator(char)
    seperator = char
end

function add_right_status(status) 
    table.insert(status_right, status)
end

wezterm.on('update-status', function(window)
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
        #status_right -- only gives us as many colours as we have segments.
    )

    local elements = {}
    table.insert(elements, { Background = { Color = 'none' } })

    for i,status in ipairs(status_right) do
        status.init()

        local color = status.getColor()
        if color == nil then
            color = gradient[i]
        end


        table.insert(elements, { Foreground = { Color = color } })
        table.insert(elements, { Text = seperator })

        status.extend(elements, fg, color)
    end

    table.insert(elements, { Foreground = { Color = '#272727' } })
    table.insert(elements, { Text = seperator })
  
    window:set_right_status(wezterm.format(elements))

end)

return {
    SOLID_LEFT_ARROW = utf8.char(0xe0b2),
    set_seperator=set_seperator,
    add_right_status=add_right_status,
}