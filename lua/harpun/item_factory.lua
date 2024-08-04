local M = {}

function M.create(bufname, key)
    local bufnr = vim.fn.bufnr(bufname, false)
    local position = { 1, 0 }
    if bufnr ~= -1 then
        position = vim.api.nvim_win_get_cursor(0)
    end
    return {
        bufname = bufname,
        key = key,
        context = {
            row = position[1],
            column = position[2],
        }
    }
end

return M
