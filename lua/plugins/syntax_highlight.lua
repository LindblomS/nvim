return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local configs = require('nvim-treesitter.configs')
            configs.setup({
                ensure_installed = { 'lua', 'rust', 'c_sharp', 'vim', 'toml', 'typescript', 'javascript', 'vue', "html", "css", "json" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
}
