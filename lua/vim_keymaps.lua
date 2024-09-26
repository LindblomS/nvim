local keymap = vim.keymap
keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
keymap.set('n', '<C-d>', '<C-d>zz')
keymap.set('n', '<C-u>', '<C-u>zz')
keymap.set('x', '<leader>p', '\"_dP"')
keymap.set('n', '<leader>y', '\"+y')
keymap.set('v', '<leader>y', '\"+y')
keymap.set('n', '<ESC>', ':noh <CR>', { silent = true })
keymap.set('n', '<leader>qa', ':%bd<CR>', { silent = true }, 'Close all buffers')
keymap.set('n', '<leader>qA', ':%bd|e#|bd#|\'"<CR>', { silent = true }, 'Close all buffers but this')
keymap.set('n', '<leader>qt', ':bprevious<bar> bdelete #<CR>', { silent = true }, 'Close this buffer')
keymap.set('i', 'kj', '<Esc>')
keymap.set('n', '<C-y>', '<C-y><C-y><C-y>')
keymap.set('n', '<C-e>', '<C-e><C-e><C-e>')
keymap.set({ "n", "v" }, "<leader>s", function()
    local word
    local visual = vim.fn.mode() == "v"
    if visual then
        local saved_reg = vim.fn.getreg("v")
        vim.cmd [[noautocmd sil norm! "vy]]
        local selection = vim.fn.getreg("v")
        vim.fn.setreg("v", saved_reg)
        word = vim.F.if_nil(nil, selection) -- vim.F is deprecated. Use something else.
    else
        word = vim.F.if_nil(nil, vim.fn.expand("<cword>"))
    end
    vim.api.nvim_feedkeys(string.format(":%%s/%s/", word), "n", false)
end, { desc = "Substitute word under cursor or selection" })
