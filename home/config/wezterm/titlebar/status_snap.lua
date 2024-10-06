local wezterm = require "wezterm"
local sh = require "util/sh"
local str = require "util/str"

function new() 

    local upgrades = nil
    local upgrades_count = nil

    return {
        init= function() 
            upgrades = str.trim(sh.execute('snap refresh --list'))
            upgrades_count = str.count_lines(upgrades)-1
        end,
        getColor= function() 
            if upgrades_count == 0 then 
                return nil
            else
                return '#FFD54F'
            end
        end,
        extend= function(elements, fg, bg) 
            local title = 'Snap'
            if bg == '#FFD54F' then
                title = title .. ' '.. upgrades_count
                fg = '#2c2c2c'
            end

            table.insert(elements, { Foreground = { Color = fg } })
            table.insert(elements, { Background = { Color = bg } })
            table.insert(elements, { Text = ' ' .. title    ..' ' })
        end
    }
end

return {
    new=new
}

--24042 / 8893 / 35023