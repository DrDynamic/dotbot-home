local io = require "io"

return {
    execute=function (command)
        local handle = io.popen(command)
        local result = handle:read("*a")
        handle:close()
        return result
    end
}