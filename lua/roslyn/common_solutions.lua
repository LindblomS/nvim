local M = {}
local filepath = vim.fn.stdpath("data") .. "/dotnet_commonly_used_solutions.txt"

function M.save(solutions)
    local file, err = io.open(filepath, "w")
    if err then
        print("error while trying to write to file: " .. filepath .. ". error: " .. err)
        return
    end

    if not file then
        return
    end

    for _, v in pairs(solutions) do
        file:write(string.format("%s\n", v))
    end
    file:close()
end

function M.get()
    local file = io.open(filepath, "r")
    if not file then
        return {}
    end
    local t = {}
    for sln in file:lines("l") do
        table.insert(t, sln)
    end
    file:close()
    return t
end

return M
