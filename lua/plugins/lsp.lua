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
                    require("roslyn").setup({
                        filewatching = false,
                        config = {
                            ["csharp|completion"] = {
                                dotnet_provide_regex_completions = false,
                                dotnet_show_completion_items_from_unimported_namespaces = true,
                                dotnet_show_name_completion_suggestions = false,
                            },
                            ["csharp|code_lens"] = {
                                dotnet_enable_references_code_lens = false,
                                dotnet_enable_tests_code_lens = false,
                            },
                            ["csharp|background_analysis"] = {
                                -- change to openFiles if performance is slow
                                dotnet_analyzer_diagnostics_scope = "fullSolution",
                                dotnet_compiler_diagnostics_scope = "fullSolution"
                            }
                        },
                        choose_sln = function(solutions)
                            if #solutions == 0 then
                                return nil
                            end

                            local names = {}
                            for i, v in ipairs(solutions) do
                                names[i] = vim.fs.basename(v)
                            end

                            local selected_index
                            vim.ui.select(names, { prompt = "Select solution" },
                                function(_, index)
                                    selected_index = index
                                end)

                            return solutions[selected_index]
                        end
                    })
                end,
                {}
            )
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    local lsp_opts = { buffer = ev.buf }
                    vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, lsp_opts)
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
