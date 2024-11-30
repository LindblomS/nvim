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

    vim.keymap.set("n", "<C-f>", function() harpun:open_menu() end)
end

function M.new()
    return setmetatable({
        items = {},
        menu = {
            buf = nil,
            closing = false,
        }
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

    local buf = vim.fn.bufnr(item.bufname)
    if buf == -1 then
        buf = vim.fn.bufadd(item.bufname)
    end

    if not vim.api.nvim_buf_is_loaded(buf) then
        vim.fn.bufload(buf)
        vim.api.nvim_set_option_value("buflisted", true, {
            buf = buf,
        })
    end

    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_feedkeys("zz", "n", false)
end

-- todo
-- should be able to rearrange items

function M:open_menu()
    local height = 8
    local width = 0 -- todo: get the length of the longest bufname and use that as a base for width
    local longest_bufname

    for _, value in pairs(self.items) do
        if #value.bufname > width then
            width = #value.bufname
            longest_bufname = value.bufname
        end
    end
    print(longest_bufname)
    print(width)

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        title = "harpun",
        title_pos = "left",
        row = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        width = width + 5,
        height = height,
        style = "minimal",
        border = "single",
    })
    self.menu = {
        buf = buf,
        closing = false,
    }

    vim.keymap.set("n", "<esc>", function()
        self:close_menu()
    end, { buffer = self.menu.buf, silent = true })

    vim.keymap.set("n", "<CR>", function()
        local index = vim.fn.line(".")
        self:close_menu()
        self:select(index)
    end, { buffer = self.menu.buf, silent = true })

    vim.api.nvim_set_option_value("buftype", "acwrite", { buf = self.menu.buf })
    vim.api.nvim_set_option_value("number", true, {
        win = win,
    })

    local items = {}
    for i, item in ipairs(self.items) do
        items[i] = item.bufname
    end
    vim.api.nvim_buf_set_lines(self.menu.buf, 0, -1, false, items)
end

function M:close_menu()
    if self.menu.closing then
        return
    end
    self.menu.closing = true
    if vim.api.nvim_buf_is_valid(self.menu.buf) then
        print("delete buf")
        vim.api.nvim_buf_delete(self.menu.buf, { force = true })
    end

    self.menu = {
        buf = nil,
        closing = false
    }
end

return M
