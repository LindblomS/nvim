return {
    {
        'akinsho/bufferline.nvim',
        version = 'v4.5.0',
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                diagnostics = 'nvim_lsp',
                offsets = {
                    filetype = 'NvimTree',
                    text = 'explorer',
                    text_align = 'left',
                    seperator = true,
                }
            },
        },
    },
}
