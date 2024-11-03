return {
    {
        'neovim/nvim-lspconfig',
        config = function(_, _)
            local lspconfig = require('lspconfig')

            -- servers that doesn't require any custom setup
            local servers = { 'rust_analyzer', "html", "jsonls" }
            for _, server in ipairs(servers) do
                lspconfig[server].setup({})
            end

            local vue_language_server_path =
            "C:/Users/samuel.lindblom/Appdata/Roaming/npm/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"
            lspconfig.ts_ls.setup({
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = vue_language_server_path,
                            languages = { "vue" },
                        },
                    },
                },
                filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
            })


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
                    })
                end,
                {}
            )
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local lsp_opts = { buffer = args.buf }
                    vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, lsp_opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, lsp_opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, lsp_opts)
                    vim.keymap.set('n', '<leader>fm', function() vim.lsp.buf.format() end, lsp_opts)

                    -- remove semantic tokens for ts_ls because it looks like shit.
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client.name == "ts_ls" then
                        client.server_capabilities.semanticTokensProvider = nil
                    end

                    local rounded = "rounded"

                    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                        vim.lsp.handlers.hover, {
                            border = rounded,
                        }
                    )

                    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                        vim.lsp.handlers.signature_help, {
                            border = rounded,
                        }
                    )

                    vim.diagnostic.config {
                        float = { border = rounded },
                    }

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
