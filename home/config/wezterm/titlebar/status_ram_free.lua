local sh = require "util/sh"
local wetzerm = require "wezterm"

function new() 
    local free=nil
    return {
        init=function() 
            free = sh.execute("awk '/MemAvailable/ { printf \"%.2f\", $2/1024/1024 }' /proc/meminfo")
        end,
        getColor=function()
            return nil
        end,
        extend=function(elements, fg, bg)
            table.insert(elements, { Foreground = { Color = fg } })
            table.insert(elements, { Background = { Color = bg } })
            table.insert(elements, { Text = ' ' ..utf8.char(0xefc5) ..'  '..free..' GB ' })
        end
    }
end

return {
    new=new
}
