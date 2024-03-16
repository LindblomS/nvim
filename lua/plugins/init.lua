return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'nvim-tree/nvim-tree.lua',
    'mfussenegger/nvim-lint',
    'kylechui/nvim-surround',
    { 'windwp/nvim-autopairs',   event = 'InsertEnter', opts = {} },
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
