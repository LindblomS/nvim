return {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'nvim-tree/nvim-tree.lua',
    'mfussenegger/nvim-lint',
    'kylechui/nvim-surround',
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                typescript = { 'prettier' },
                javascript = { 'prettier' },
            },
        }
    }
}
