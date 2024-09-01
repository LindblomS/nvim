return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path'
        },
        opts = function()
            local cmp = require('cmp')
            return {
                window = {
                    completion = cmp.config.window.bordered()
                },
                mapping = cmp.mapping.preset.insert({
                    ['<esc>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-j>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-k>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
                }),
            }
        end,
        config = function(_, opts)
            require('cmp').setup(opts)
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lspconfig = require('lspconfig')
            local servers = { 'lua_ls', 'rust_analyzer', 'tsserver', 'volar', }
            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = capabilities
                })
            end
        end,
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        dependencies = { 'hrsh7th/nvim-cmp' },
        config = function(_, _)
            require('nvim-autopairs').setup({})
            local autopairs_cmp = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                autopairs_cmp.on_confirm_done()
            )
        end
    }
}
