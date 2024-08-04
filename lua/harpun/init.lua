--- WIP
--- A file navigation plugin named harpun which basically is just a trimmed down version of harpoon.
local M = {}
local P = {} -- private
M.__index = M

function M.setup()
    local harpun = M.new()
    vim.keymap.set("n", "<leader>h", function() harpun:add(1) end)
    vim.keymap.set("n", "<leader>j", function() harpun:add(2) end)
    vim.keymap.set("n", "<leader>k", function() harpun:add(3) end)
    vim.keymap.set("n", "<leader>l", function() harpun:add(4) end)

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
        replace = false,
    }, M)
end

function P.create_item(bufname)
    local bufnr = vim.fn.bufnr(bufname, false)
    local position = { 1, 0 }
    if bufnr ~= -1 then
        position = vim.api.nvim_win_get_cursor(0)
    end
    return {
        bufname = bufname,
        context = {
            row = position[1],
            column = position[2],
        }
    }
end

function P.get_bufname()
    return P.normalize_path(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), vim.loop.cwd())
end

function P.normalize_path(bufname, root)
    -- is plenary really necessary?
    return require("plenary.path"):new(bufname):make_relative(root)
end

function M:add(index)
    local item = self.items[index]
    if item then
        self:prompt(item.bufname, index)
        return
    else
        item = P.create_item(P.get_bufname())
        self.items[index] = item
    end
end

function P.replace_at_index(items, index, bufname)
    items[index] = P.create_item(bufname)
end

function M:select(index)
    local item = self.items[index]

    if not item then
        return
    end

    local bufnr = vim.fn.bufnr(P.to_exact_name(item.bufname))
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

        -- can item.context.row/column really be nil here?
        vim.api.nvim_win_set_cursor(0, {
            item.context.row or 1,
            item.context.column or 0,
        })
    end
end

function P.to_exact_name(bufname)
    return "^" .. bufname .. "$"
end

function M:print()
    local items = {}
    for i, v in ipairs(self.items) do
        items[i] = v.bufname
    end
    print(vim.inspect(items))
end

function M:prompt(bufname, index)
    local current_bufname = P.get_bufname()
    local height = 8
    local width = 100
    local buf = vim.api.nvim_create_buf(false, true)
    local win_id = vim.api.nvim_open_win(buf, true, {
        title = "File already harpun:ed",
        relative = "editor",
        row = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        style = "minimal",
        border = "single",
    })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        bufname .. " is already harpun:ed",
        "replace? y (yes), n (no)"
    })

    vim.keymap.set("n", "y", function()
        P.replace_at_index(self.items, index, current_bufname)
        vim.api.nvim_win_close(win_id, true)
    end, { buffer = buf, silent = true })

    vim.keymap.set("n", "n", function()
        vim.api.nvim_win_close(win_id, true)
    end, { buffer = buf, silent = true })
end

return M
