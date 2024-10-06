local sh = require "util/sh"
local str = require "util/str"

function new() 

    local uptime = str.trim(sh.execute('uptime -p'))
    local uptime_minutes = tonumber(str.trim(sh.execute("echo $(awk '{print $1}' /proc/uptime) / 60 | bc")))
    return {
        init= function() 
        end,
        getColor= function()
            if uptime_minutes > ((9*60) + 30) then 
                return '#e53935'
            elseif uptime_minutes > (8*60) then
                return '#FFD54F'
            else
                return nil
            end
        end,
        extend= function(elements, fg, bg) 

            if bg == '#e53935' then
                fg='#2c2c2c'
            elseif bg == '#FFD54F' then
                fg='#2c2c2c'
            end

            table.insert(elements, { Foreground = { Color = fg } })
            table.insert(elements, { Background = { Color = bg } })
            table.insert(elements, { Text = ' ' .. uptime..' ' })
        end
    }
end

return  {
    new=new
}