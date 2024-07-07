vim.g.mapleader = ' '

local o = vim.o
o.nu = true
o.relativenumber = true
o.wrap = false

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.autoindent = true

o.swapfile = false
o.backup = false

o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true

o.scrolloff = 8

local km = vim.keymap
km.set('v', 'J', ":m '>+1<CR>gv=gv")
km.set('v', 'K', ":m '<-2<CR>gv=gv")
km.set('n', '<C-d>', '<C-d>zz')
km.set('n', '<C-u>', '<C-u>zz')
km.set('n', 'n', 'nzzzv')
km.set('n', 'N', 'Nzzzv')
km.set('x', '<leader>p', '\"_dP"')
km.set('n', '<leader>y', '\"+y')
km.set('v', '<leader>y', '\"+y')
km.set('n', '<S-l>', ':bnext<CR>', { silent = true })
km.set('n', '<S-h>', ':bprevious<CR>', { silent = true })
km.set('n', '<ESC>', ':noh <CR>', { silent = true })
km.set('i', '<C-h>', '<C-o>h')
km.set('i', '<C-l>', '<C-o>a')
km.set('n', '<leader>qa', ':%bd<CR>', { silent = true }, 'Close all buffers')
km.set('n', '<leader>qA', ':%bd|e#|bd#|\'"<CR>', { silent = true }, 'Close all buffers but this')
km.set('n', '<leader>qt', ':bprevious<bar> bdelete #<CR>', { silent = true }, 'Close this buffer')
km.set('i', 'kj', '<Esc>')
km.set('n', '<C-y>', '<C-y><C-y>')
km.set('n', '<C-e>', '<C-e><C-e>')
