
local wezterm = require "wezterm"

local status_right = {}
local seperator_start = '|'
local seperator_middle = nil

function set_seperator(start, middle)
    seperator_start = start
    seperator_middle = middle
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

    local last_color = nil
    for i,status in ipairs(status_right) do
        status.init()

        local color = status.getColor()
        if color == nil then
            color = gradient[i]
        end

        if last_color == color and  seperator_middle ~= nil then 
            table.insert(elements, { Foreground = { Color = '#2c2c2c' } })
            table.insert(elements, { Text = utf8.char(0xe0b3) })
        else
            table.insert(elements, { Foreground = { Color = color } })
            table.insert(elements, { Text = seperator_start })
        end

        status.extend(elements, fg, color)

        if type(color) == 'userdata' then
             last_color = color
        else
             last_color = color:upper() 
        end
    end

    table.insert(elements, { Foreground = { Color = '2c2c2c' } })
    table.insert(elements, { Text = seperator_start })
  
    window:set_right_status(wezterm.format(elements))

end)

return {
    SOLID_LEFT_ARROW = utf8.char(0xe0b2),
    SOLID_LEFT_ARROW_INVERSE = utf8.char(0xe0d6),
    SOLID_LEFT_ARROW_DIVIDER = utf8.char(0xe0b3),
    set_seperator=set_seperator,
    add_right_status=add_right_status,
}