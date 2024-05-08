return {
    {
        'numToStr/Comment.nvim',
        opts = {
            mappings = false,
        },
        config = function(_, opts)
            local comment = require('Comment')
            comment.setup(opts)
            local api = require('Comment.api')
            local map = vim.keymap.set
            map('n', '<leader>/', api.call('comment.linewise.current', 'g@$'),
                { expr = true, desc = 'Comment current line' })
            map('n', '<leader>\\', api.call('uncomment.linewise.current', 'g@$'),
                { expr = true, desc = 'Uncomment current line' })
            map('v', '<leader>/', api.call('comment.linewise', 'g@'), { expr = true, desc = 'Comment selection' })
            map('v', '<leader>\\', api.call('uncomment.linewise', 'g@'), { expr = true, desc = 'Uncomment selection' })
        end,
        keys = {
            { '<leader>/' },
            { '<leader>\\' },
            { '<leader>/',  mode = 'v' },
            { '<leader>\\', mode = 'v' },
        }
    }
}
