local M = {}

---@class RoslynNvimDirectoryWithFiles
---@field directory string
---@field files string[]

---Gets the root directory of the first project file and find all related project file to that directory
---@param buffer integer
---@return RoslynNvimDirectoryWithFiles?
function M.get_project_files(buffer)
    local directory = vim.fs.root(buffer, function(name)
        return name:match("%.csproj$") ~= nil
    end)

    if not directory then
        return nil
    end

    local files = vim.fs.find(function(name, _)
        return name:match("%.csproj$")
    end, { path = directory, limit = math.huge })

    return {
        directory = directory,
        files = files,
    }
end

local commonly_used_sln_files_filepath = vim.fn.stdpath("data") .. "/commonly_used_sln_files.txt"
local function read_file()
    local path = commonly_used_sln_files_filepath
    local file = io.open(path, "r")
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

local function get_commonly_used_sln_files()
    local filepath = commonly_used_sln_files_filepath
    local file, err = io.open(filepath, "r")
    if err then
        print("couldn't read file: " .. filepath .. ". error: " .. err)
        return {}
    end
    if not file then
        print("couldn't read file: " .. filepath .. ". file was nil")
        return {}
    end
    local sln_files = {}
    print("reading from file: " .. filepath)
    for sln in file:lines("l") do
        table.insert(sln_files, sln)
    end
    file:close()
    return sln_files
end

local function table_contains(table, element)
    for _, v in pairs(table) do
        if v == element then
            return true
        end
    end
    return false
end

---Find the solution file from the current buffer.
---Recursively see if we have any other solution files, to potentially
---give th user an option to choose which solution file to use
---@param buffer integer
---@return string[]?
function M.get_solution_files(buffer)
    local directory = vim.fs.root(buffer, function(name)
        return name:match("%.sln$") ~= nil
    end)

    if not directory then
        return nil
    end

    local sln_files = vim.fs.find(function(name, _)
        return name:match("%.sln$")
    end, { type = "file", limit = math.huge, path = directory })
    local common_sln_files = get_commonly_used_sln_files()
    local sorted_sln_files = {}
    for _, v in pairs(common_sln_files) do
        if table_contains(sln_files, v) then
            table.insert(sorted_sln_files, v)
        end
    end
    for _, v in pairs(sln_files) do
        if not table_contains(sorted_sln_files, v) then
            table.insert(sorted_sln_files, v)
        end
    end
    return sorted_sln_files
end

function M.save_commonly_used_sln_file(sln)
    local filepath = commonly_used_sln_files_filepath
    local file, err = io.open(filepath, "r")
    if err then
        print("couldn't read file: " .. filepath .. ". error: " .. err)
    end

    if not file then -- file doesn't exist
        print("creating file: " .. filepath)
        file, err = io.open(filepath, "w")
        if err then
            print("couldn't create file: " .. filepath .. ". error: " .. err)
        else
            if file then
                file:write(sln)
                file:close()
            end
        end
        return
    end

    local sln_files = {}
    for sln_file in file:lines("l") do
        table.insert(sln_files, sln_file)
    end
    file:close()

    local indexToRemove
    for i, v in ipairs(sln_files) do
        if v == sln then
            indexToRemove = i
        end
    end
    if indexToRemove then
        table.remove(sln_files, indexToRemove)
    end
    table.insert(sln_files, 1, sln)
    local file, err = io.open(filepath, "w")
    if err then
        print("error while trying to write to file: " .. filepath .. ". error: " .. err)
        return
    end

    if file then
        for _, v in pairs(sln_files) do
            file:write(string.format("%s\n", v))
        end
        file:close()
    else
        print("couldn't write to file: " .. filepath .. ". file was nil")
    end
end

--- Find a path to sln file that is likely to be the one that the current buffer
--- belongs to. Ability to predict the right sln file automates the process of starting
--- LSP, without requiring the user to invoke CSTarget each time the solution is open.
--- The prediction assumes that the nearest csproj file (in one of parent dirs from buffer)
--- should be a part of the sln file that the user intended to open.
---@param buffer integer
---@param sln_files string[]
---@return string?
function M.predict_sln_file(buffer, sln_files)
    local csproj = M.get_project_files(buffer)
    if not csproj or #csproj.files > 1 then
        return nil
    end

    local csproj_filename = vim.fn.fnamemodify(csproj.files[1], ":t")

    -- Look for a solution file that contains the name of the project
    -- Predict that to be the "correct" solution file if we find the project name
    for _, file_path in ipairs(sln_files) do
        local file = io.open(file_path, "r")

        if not file then
            return nil
        end

        local content = file:read("*a")
        file:close()

        if content:find(csproj_filename, 1, true) then
            return file_path
        end
    end

    return nil
end

return M
