require('nvim-tree').setup({
    view = {
        width = 50,
    },
    git = {
        enable = false,
        ignore = true,
    }
})

vim.keymap.set('n', '<leader>e', ':NvimTreeFindFile <CR>')
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle <CR>')
