return {
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function()
            local palette = require('kanagawa.colors').setup({ theme = 'dragon' }).palette
            local opts = {
                colors = {
                    theme = {
                        wave = {
                            ui = {
                                fg         = palette.dragonWhite,
                                fg_dim     = palette.oldWhite,
                                fg_reverse = palette.waveBlue1,

                                bg_dim     = palette.dragonBlack1,
                                -- bg_gutter  = palette.dragonBlack4,

                                bg_m3      = palette.dragonBlack0,
                                bg_m2      = palette.dragonBlack1,
                                bg_m1      = palette.dragonBlack2,
                                bg         = palette.dragonBlack3,
                                bg_p1      = palette.dragonBlack4,
                                bg_p2      = palette.dragonBlack5,

                                special    = palette.dragonGray3,
                                whitespace = palette.dragonBlack6,
                                nontext    = palette.dragonBlack6,

                                bg_visual  = palette.waveBlue1,
                                bg_search  = palette.waveBlue2,

                                pmenu      = {
                                    fg       = palette.fujiWhite,
                                    fg_sel   = "none",
                                    bg       = palette.waveBlue1,
                                    bg_sel   = palette.waveBlue2,
                                    bg_thumb = palette.waveBlue2,
                                    bg_sbar  = palette.waveBlue1,
                                },

                                float      = {
                                    fg        = palette.oldWhite,
                                    bg        = palette.dragonBlack0,
                                    fg_border = palette.sumiInk6,
                                    bg_border = palette.dragonBlack0,
                                },
                            }
                        },
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
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        Boolean = { bold = false },
                        NormalFloat = { bg = "none" },
                        FloatBorder = { bg = "none" },
                        FloatTitle = { bg = "none" },
                        TelescopeTitle = { fg = theme.ui.special, bold = true, },
                        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1, },
                        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1, },
                        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1, },
                        TelescopePreviewNormal = { bg = theme.ui.bg_dim, },
                        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim, },
                    }
                end,
            }
            require('kanagawa').setup(opts)
            vim.opt.background = 'dark'
            vim.cmd('colorscheme kanagawa')
        end
    },
}
