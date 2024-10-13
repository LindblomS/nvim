local M = {}

function M.get_bufname()
    return M.normalize_path(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), vim.fn.getcwd())
end

function M.normalize_path(bufname, root)
    -- is plenary really necessary?
    return require("plenary.path"):new(bufname):make_relative(root)
end

return M
