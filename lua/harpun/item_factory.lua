local M = {}

function M.create(bufname, key)
    return {
        bufname = bufname,
        key = key,
    }
end

return M
