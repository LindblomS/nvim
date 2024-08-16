local modes = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "VISUAL LINE",
    [""] = "VISUAL BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT LINE",
    [""] = "SELECT BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "VISUAL REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MOAR",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}

local function mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format(" %s ", modes[current_mode]):upper()
end

local function lsp()
    local count = {}
    local levels = {
        errors = "Error",
        warnings = "Warn",
        info = "Info",
        hints = "Hint",
    }
    for key, level in pairs(levels) do
        count[key] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local errors = ""
    local warnings = ""
    local info = ""
    local hints = ""

    if count["errors"] ~= 0 then
        errors = string.format("%s Errors %s", "%#DiagnosticError#", count["errors"])
    end

    if count["warnings"] ~= 0 then
        warnings = string.format("%s Warnings %s", "%#DiagnosticWarn#", count["warnings"])
    end

    if count["info"] ~= 0 then
        info = string.format("%s Info %s", "%#DiagnosticInfo#", count["info"])
    end

    if count["hints"] ~= 0 then
        hints = string.format("%s Hints %s", "%#DiagnosticHint#", count["hints"])
    end

    return string.format("%s %s %s %s", errors, warnings, info, hints)
end

local function lineinfo()
    return "%-25(%3l:%-3c %p%%%)"
end

Statusline = {}

Statusline.active = function()
    return table.concat({
        mode(),
        "%f",
        lsp(),
        "%#Statusline#",
        lineinfo(),
    })
end

function Statusline.inactive()
    return " %f"
end

local function set_statusline_option(value)
    vim.api.nvim_set_option_value("statusline", value, { scope = "local" })
end

vim.api.nvim_create_augroup("Statusline", {})
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = "Statusline",
    callback = function(_)
        set_statusline_option(Statusline.active())
    end
})
vim.api.nvim_create_autocmd({ "BufLeave" }, {
    group = "Statusline",
    callback = function(_)
        set_statusline_option(Statusline.inactive())
    end
})
