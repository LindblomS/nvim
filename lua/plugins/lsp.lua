return {
    {
        'neovim/nvim-lspconfig',
        config = function(_, _)
            local lspconfig = require('lspconfig')

            -- servers that doesn't require any custom setup
            local servers = { 'rust_analyzer', 'ts_ls', 'volar', "html" }
            for _, server in ipairs(servers) do
                lspconfig[server].setup({})
            end

            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                },
            })

            lspconfig.eslint.setup({
                on_attach = function(_, bufnr)
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        command = 'EslintFixAll',
                    })
                end
            })

            vim.api.nvim_create_user_command('Roslyn',
                function()
                    local function get_sln_names_and_paths(sln_paths)
                        local table = {}
                        for _, path in ipairs(sln_paths) do
                            local name = vim.fs.basename(path)
                            table[name] = path
                        end
                        return table
                    end

                    require("roslyn").setup({
                        filewatching = false,
                        choose_sln = function(sln_files)
                            if #sln_files == 0 then
                                return nil
                            end
                            local names_and_paths = get_sln_names_and_paths(sln_files)
                            local names = {}
                            for name, _ in pairs(names_and_paths) do
                                table.insert(names, name)
                            end

                            local selected_sln
                            vim.ui.select(names, { prompt = "Select solution" },
                                function(name)
                                    selected_sln = name
                                end)

                            return names_and_paths[selected_sln]
                        end
                    })
                end,
                {}
            )
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    local lsp_opts = { buffer = ev.buf }
                    vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help, lsp_opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, lsp_opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, lsp_opts)
                    vim.keymap.set('n', '<leader>fm', function() vim.lsp.buf.format() end, lsp_opts)

                    vim.api.nvim_create_autocmd('BufWritePre', {
                        pattern = { '*.{cs,rs,lua}' },
                        callback = function()
                            vim.lsp.buf.format()
                        end
                    })
                end
            })
        end
    },
}
