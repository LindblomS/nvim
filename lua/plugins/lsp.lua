return {
    {
        'neovim/nvim-lspconfig',
        config = function(_, _)
            local lspconfig = require('lspconfig')

            -- servers that doesn't require any custom setup
            local servers = { 'rust_analyzer', 'tsserver', 'volar' }
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

            vim.api.nvim_create_user_command('Omnisharp',
                function()
                    local function get_sln_file()
                        local function get_table_with_sln_name_and_path(sln_paths)
                            local table = {}
                            for _, path in ipairs(sln_paths) do
                                local name = vim.fs.basename(path)
                                table[name] = path
                            end
                            return table
                        end

                        local sln_paths = vim.fs.find(function(name, _)
                            return name:match('.*%.sln$')
                        end, { limit = math.huge, type = 'file', stop = '.' })
                        local sln_names_and_paths = get_table_with_sln_name_and_path(sln_paths)

                        local sln_names = {}
                        for k, _ in pairs(sln_names_and_paths) do
                            table.insert(sln_names, k)
                        end

                        local selected_sln_name = ''
                        if #sln_names > 0 then
                            vim.ui.select(sln_names, { prompt = 'Select solution' },
                                function(selection)
                                    selected_sln_name = selection
                                end)
                        end
                        return sln_names_and_paths[selected_sln_name]
                    end


                    -- This capability will generate EPERM errors on windows for omnisharp.
                    local capabilities = vim.lsp.protocol.make_client_capabilities()
                    capabilities.workspace.didChangeWatchedFiles = false

                    lspconfig.omnisharp.setup({
                        capabilities = capabilities,
                        root_dir = function()
                            return './'
                        end,
                        cmd = {
                            'OmniSharp',
                            '-s',
                            string.format('%s', get_sln_file()),
                            '-z',
                            '--hostPID',
                            tostring(vim.fn.getpid()),
                            '--languageserver',
                            '--encoding',
                            'utf-8',
                            'FormattingOptions:EnableEditorConfigSupport=true',
                            'FormattingOptions:OrganizeImports=true',
                            'RoslynExtensionsOptions:EnableAnalyzersSupport=true',
                            'RoslynExtensionsOptions:AnalyzeOpenDocumentsOnly=true'
                        },
                        on_new_config = function(config, _)
                            -- Disable the handling of multiple workspaces in a single instance
                            config.capabilities = vim.deepcopy(config.capabilities)
                            config.capabilities.workspace.workspaceFolders = false -- https://github.com/OmniSharp/omnisharp-roslyn/issues/909
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
