--- A file navigation plugin inspired by harpoon
local item_factory = require("harpun.item_factory")
local replace = require("harpun.replace")
local util = require("harpun.util")
local M = {}
M.__index = M

function M.setup()
    local harpun = M.new()
    vim.keymap.set("n", "<leader>h", function() harpun:add(1, "h") end)
    vim.keymap.set("n", "<leader>j", function() harpun:add(2, "j") end)
    vim.keymap.set("n", "<leader>k", function() harpun:add(3, "k") end)
    vim.keymap.set("n", "<leader>l", function() harpun:add(4, "l") end)

    vim.keymap.set("n", "<C-h>", function() harpun:select(1) end)
    vim.keymap.set("n", "<C-j>", function() harpun:select(2) end)
    vim.keymap.set("n", "<C-k>", function() harpun:select(3) end)
    vim.keymap.set("n", "<C-l>", function() harpun:select(4) end)

    vim.api.nvim_create_user_command('Harpun', function()
        harpun:print()
    end, {})
end

function M.new()
    return setmetatable({
        items = {},
    }, M)
end

function M:add(index, key)
    if not index or index < 1 then
        error("Argument error: index cannot be nil or less than 1. index was " .. (index or "nil"))
    end
    if not key then
        error("Argument error: key cannot be nil")
    end

    local item = self.items[index]
    if item then
        replace.display_prompt(item.bufname, key, util.get_bufname(), index, self.items)
        return
    else
        item = item_factory.create(util.get_bufname(), key)
        self.items[index] = item
    end
end

function M:select(index)
    if not index or index < 1 then
        error("Argument error: index cannot be nil or less than 1. index was " .. (index or "nil"))
    end

    local item = self.items[index]
    if not item then
        return
    end

    local bufnr = vim.fn.bufnr(util.to_exact_name(item.bufname))
    local set_position = false
    if bufnr == -1 then
        set_position = true
        bufnr = vim.fn.bufadd(item.bufname)
    end

    if not vim.api.nvim_buf_is_loaded(bufnr) then
        vim.fn.bufload(bufnr)
        vim.api.nvim_set_option_value("buflisted", true, {
            buf = bufnr,
        })
    end

    vim.api.nvim_set_current_buf(bufnr)
    if set_position then
        local lines = vim.api.nvim_buf_line_count(bufnr)
        if item.context.row > lines then
            item.context.row = lines
        end

        local row = item.context.row
        local row_text = vim.api.nvim_buf_get_lines(0, row - 1, row, false)
        local column = #row_text[1] -- wtf does this even do?

        if item.context.column > column then
            item.context.column = column
        end

        vim.api.nvim_win_set_cursor(0, {
            item.context.row,
            item.context.column,
        })
    end
    vim.api.nvim_feedkeys("zz", "n", false)
end

function M:print()
    local items = {}
    for i, item in ipairs(self.items) do
        items[i] = item.bufname .. ", " .. item.key
    end
    print(vim.inspect(items))
end

return M
