return {
    {
        'nvim-tree/nvim-tree.lua',
        opts = {
            view = {
                width = 50,
            },
            git = {
                enable = false,
                ignore = true,
            },
        },
        keys = {
            { '<leader>e' }
        },
        config = function(_, opts)
            require('nvim-tree').setup(opts)
            local set_opts = { silent = true }
            vim.keymap.set('n', '<leader>e', ':NvimTreeFindFile <CR>', set_opts)
            vim.keymap.set('n', '<C-n>', ':NvimTreeToggle <CR>', set_opts)
        end
    }
}
