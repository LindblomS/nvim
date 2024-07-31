local M = {}
M.__index = M

function M.new()
    return setmetatable({
        win_id = nil,
        bufnr = nil,
        active_list = nil,
    }, M)
end

function M:create_window()
    local window = vim.api.nvim_list_uis()
    local width = 100
    if #window > 0 then
        width = math.floor(window[1].width * 1)
    end

    local height = 8
    local bufnr = vim.api.nvim_create_buf(false, true)
    local win_id = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        title = "Harpoon",
        title_pos = "left",
        row = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        style = "minimal",
        border = "single",
    })
    if win_id == 0 then
        self.bufnr = bufnr
        self:close_menu()
        error("Failed to create window")
    end

    self.win_id = win_id
    vim.api.nvim_set_option_value("number", true, {
        win = win_id
    })
    return win_id, bufnr
end

function M:toggle_quick_menu(list)
    print("toggle")
    local win_id, bufnr = self:create_window()
    self.win_id = win_id
    self.bufnr = bufnr
    self.active_list = list
    local contents = self.active_list:display()
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, contents)
end

return M
