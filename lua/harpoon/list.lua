local M = {}
local P = {} -- private
M.__index = M

function M.new()
    local items = {}
    return setmetatable({
        items = items,
        name = "the name",
        _length = 1,
        _index = 1,
    }, M)
end

function P.create_item()
    local name = P.normalize_path(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), vim.loop.cwd())
    local bufnr = vim.fn.bufnr(name, false)
    local position = { 1, 0 }
    if bufnr ~= -1 then
        position = vim.api.nvim_win_get_cursor(0)
    end
    return {
        value = name,
        context = {
            row = position[1],
            column = position[2],
        }
    }
end

function P.normalize_path(bufname, root)
    return require("plenary.path"):new(bufname):make_relative(root)
end

function M:add()
    local item = P.create_item()
    local index = P.index_of(self.items, self._length, item)
    if index == -1 then
        local first_available_index = self._length + 1
        for i = 1, self._length + 1 do
            if self.items[i] == nil then -- if there is a hole in the sequence
                first_available_index = i
                break
            end
        end

        self.items[first_available_index] = item
        if first_available_index > self._length then
            self._length = first_available_index
        end
    end
end

function P.index_of(items, length, item)
    local index = -1
    for i = 1, length do
        local element = items[i]
        if item == element then
            index = i
            break
        end
    end
    return index
end

function M:select(index)
    local item = self.items[index]

    if not item then
        return
    end

    local bufnr = vim.fn.bufnr(P.to_exact_name(item.value))
    local set_position = false
    if bufnr == -1 then
        set_position = true
        bufnr = vim.fn.bufadd(item.value)
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

function P.to_exact_name(value)
    return "^" .. value .. "$"
end

function M:display()
    local out = {}
    for i = 1, self._length do
        local v = self.items[i]
        out[i] = v == (nil and "") or v.value
    end
    return out
end

return M
