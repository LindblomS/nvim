return {
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
        enabled = false,
        opts = {
            bold = false,
            italic = {
                strings = false,
                emphasis = false,
                comments = false,
                operators = false,
                folds = false,
            },
            contrast = 'hard',
        },
        config = function(_, opts)
            require('gruvbox').setup(opts)
            vim.opt.background = 'dark'
            vim.cmd([[colorscheme gruvbox]])
        end
    },
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        enabled = true,
        opts = {
            undercurl = false,
            commentStyle = { italic = false },
            keywordStyle = { italic = false },
            statementStyle = { bold = false },
            background = {
                dark = 'wave',
            },
            overrides = function(colors)
                local theme = colors.theme
                return {
                    TelescopeTitle = { fg = theme.ui.special, bold = true, },
                    TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                    TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1, },
                    TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1, },
                    TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1, },
                    TelescopePreviewNormal = { bg = theme.ui.bg_dim, },
                    TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim, },
                }
            end,
        },
        config = function(_, opts)
            require('kanagawa').setup(opts)
            vim.opt.background = 'dark'
            vim.cmd([[colorscheme kanagawa]])
        end
    }
}
