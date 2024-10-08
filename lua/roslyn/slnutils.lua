local M = {}
local Common_solutions = require("roslyn.common_solutions")

function M.set_last_used_solution(last_used_solution)
    local solutions = Common_solutions.get()
    local indexToRemove
    for i, v in ipairs(solutions) do
        if v == last_used_solution then
            indexToRemove = i
            break
        end
    end
    if indexToRemove then
        table.remove(solutions, indexToRemove)
    end
    table.insert(solutions, 1, last_used_solution)
    Common_solutions.save(solutions)
end

local function table_contains(table, element)
    for _, v in pairs(table) do
        if string.lower(v) == string.lower(element) then
            return true
        end
    end
    return false
end

local function sort_last_used_solution(solutions)
    local common_solutions = Common_solutions.get()
    local sorted = {}
    for _, v in pairs(common_solutions) do
        if table_contains(solutions, v) then
            table.insert(sorted, v)
        end
    end
    for _, v in pairs(solutions) do
        if not table_contains(sorted, v) then
            table.insert(sorted, v)
        end
    end
    return sorted
end

---@param solutions string[]
local function choose_solution(solutions)
    if #solutions == 0 then
        return nil
    end

    if #solutions == 1 then
        return solutions[1]
    end

    local names = {}
    for i, v in ipairs(solutions) do
        names[i] = vim.fs.basename(v)
    end

    local selected_index
    vim.ui.select(names, { prompt = "Select solution" },
        function(_, index)
            selected_index = index
        end)

    return solutions[selected_index]
end

function M.get_solution(buffer)
    local directory = vim.fs.root(buffer, function(name)
        return name:match("%.sln$") ~= nil
    end)

    if not directory then
        return nil
    end

    local solutions = vim.fs.find(function(name, _)
        return name:match("%.sln$")
    end, { type = "file", limit = math.huge, path = directory })

    return choose_solution(sort_last_used_solution(solutions))
end

return M
