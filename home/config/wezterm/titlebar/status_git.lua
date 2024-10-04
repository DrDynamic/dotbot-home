local wezterm = require "wezterm"
local io = require "io"
local str = require "str"

function new(title, repository) 

    local local_changes = nil
    local commits = nil
    local changes_count = 0

    return {
        init= function() 
            local_changes = getLocalChanges(repository)
            commits = getCommitDiff(repository)
            changes_count = local_changes.changes 
            + local_changes.untracked
            + commits.local_ahead
            + commits.remote_ahead
        end,
        getColor= function() 
            if changes_count == 0 then 
                return nil
            else
                return '#FFD54F'
            end
        end,
        extend= function(elements, fg, bg) 

            icons = ' '
                if local_changes.changes ~= 0 then 
                    icons = icons..'!'
                end
                if local_changes.untracked ~= 0 then
                    icons = icons..'?'
                end
                if commits.local_ahead ~= 0 then
                    icons = icons..'⇡'
                end
                if commits.remote_ahead ~= 0 then
                    icons = icons..'⇣'
                end

            if changes_count ~= 0 then 
                fg = '#2c2c2c'
            end

            table.insert(elements, { Foreground = { Color = fg } })
            table.insert(elements, { Background = { Color = bg } })
            table.insert(elements, { Text = ' ' .. title .. icons ..' ' })
        end
    }
end

function getLocalChanges(repository)
    result = execute('git -C '..repository..' status -s')

    local changes = 0
    local untracked = 0

    for line in str.lines(result) do
        line = str.trim(line)
        if str.startsWith(line, '?') then
            untracked = untracked + 1
        elseif line ~= '' then
            changes = changes + 1
        end
    end

    return {
        changes=changes,
        untracked=untracked
    }
end

function getCommitDiff(repository)
    local curerentBranch = str.trim(execute('git -C '..repository..' branch --show-current'))
    local localAhead = str.trim(execute('git -C '..repository..' rev-list --count --ignore-missing origin/'..curerentBranch..'..'..curerentBranch))
    local remoteAhead = str.trim(execute('git -C '..repository..' rev-list --count --ignore-missing '..curerentBranch..'..origin/'..curerentBranch))
    
    return {
        local_ahead = tonumber(localAhead),
        remote_ahead = tonumber(remoteAhead)
    }

end

function execute(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end


return {
    new=new
}

--24042 / 8893 / 35023