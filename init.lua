require('customize_vim')

-- disable netrw for nvim-tree
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
    change_detection = {
        enabled = true,
        notify = false,
    }
})

local harpoon = require("harpoon")
local h = harpoon.new()
vim.keymap.set("n", "<leader>a", function() h:list():add() end)
vim.keymap.set("n", "<leader>A", function() h.ui:toggle_quick_menu(h:list()) end)
vim.keymap.set("n", "<C-h>", function() h:list():select(1) end)
vim.keymap.set("n", "<C-j>", function() h:list():select(2) end)
vim.keymap.set("n", "<C-k>", function() h:list():select(3) end)
vim.keymap.set("n", "<C-l>", function() h:list():select(4) end)
