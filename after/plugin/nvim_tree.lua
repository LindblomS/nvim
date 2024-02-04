require('nvim-tree').setup({
    view = {
        width = 50,
    },
    git = {
        enable = false,
        ignore = true,
    }
})

vim.keymap.set('n', '<leader>e', ':NvimTreeFocus <CR>')
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle <CR>')
