return {
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function()
            local opts = {
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = 'none',
                            },
                        },
                    },
                },
                undercurl = false,
                commentStyle = { italic = false },
                keywordStyle = { italic = false },
                statementStyle = { bold = false },
                background = {
                    dark = 'wave',
                },
                overrides = function()
                    return {
                        FloatBorder = { bg = "none" },
                        Boolean = { bold = false },
                        NormalFloat = { bg = "none" },
                        FloatTitle = { bg = "none" },
                    }
                end,
            }
            require('kanagawa').setup(opts)
            vim.opt.background = 'dark'
            vim.cmd('colorscheme kanagawa')
        end
    },
}
