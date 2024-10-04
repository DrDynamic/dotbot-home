local string = require "string"
return {
    trim = function (s) 
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    end,
    startsWith = function(s, with)
        return string.sub(s,1,string.len(with)) == with
    end,
    lines=function(s)
        if s == nil then 
            return {} 
        end
        return s:gmatch("[^\n]+")
    end
}