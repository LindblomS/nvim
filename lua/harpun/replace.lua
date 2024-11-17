local item_factory = require("harpun.item_factory")
local M = {}
M.__index = M

function M.display_prompt(bufname, key, current_bufname, index, items)
    local replace = setmetatable({
        bufname = bufname,
        key = key,
        current_bufname = current_bufname,
        index = index,
        items = items,
    }, M)
    replace:prompt()
end

function M:prompt()
    local height = 8
    local width = 100 -- todo: get the length of the longest bufname and use that as a base for width
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
        self.bufname .. " is already harpun:ed",
        "replace? y (yes), n (no)"
    })
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
    self:set_keymaps(buf, win_id)
end

function M:set_keymaps(buf, win_id)
    vim.keymap.set("n", "y", function()
        self:replace()
        vim.api.nvim_win_close(win_id, true)
    end, { buffer = buf, silent = true })

    vim.keymap.set("n", "n", function()
        vim.api.nvim_win_close(win_id, true)
    end, { buffer = buf, silent = true })

    vim.keymap.set("n", "<esc>", function()
        vim.api.nvim_win_close(win_id, true)
    end, { buffer = buf, silent = true })
end

function M:replace()
    self.items[self.index] = item_factory.create(self.current_bufname, self.key)
end

return M
