local Ui = require("harpoon.ui")
local List = require("harpoon.list")

local M = {}
M.__index = M

function M.new()
    return setmetatable({
        ui = Ui.new(),
        inner_list = List.new(),
    }, M)
end

function M:list()
    print("list")
    return self.inner_list
end

return M
