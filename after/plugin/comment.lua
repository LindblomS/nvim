require('Comment').setup {
    mappings = false
}

local api = require('Comment.api')
local map = vim.keymap.set
map('n', '<leader>/', api.call('comment.linewise.current', 'g@$'), { expr = true, desc = 'Comment current line' })
map('n', '<leader>\\', api.call('uncomment.linewise.current', 'g@$'), { expr = true, desc = 'Uncomment current line' })
map('v', '<leader>/', api.call('comment.linewise', 'g@'), { expr = true })
map('v', '<leader>\\', api.call('uncomment.linewise', 'g@'), { expr = true })
