return {
    {
        'kylechui/nvim-surround',
        config = true
    },
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
