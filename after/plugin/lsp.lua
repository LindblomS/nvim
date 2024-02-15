require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'tsserver',
        'volar',
    }
}

local lsp_config = require("lspconfig")
lsp_config.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

lsp_config.rust_analyzer.setup {}
lsp_config.tsserver.setup {}
lsp_config.volar.setup {}

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>fm', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end
})
