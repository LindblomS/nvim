return {
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' },
        config = function(_, opts)
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'rust_analyzer',
                    'tsserver',
                    'volar',
                    'omnisharp',
                },
            })
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

            vim.api.nvim_create_user_command('OmniSharp',
                function()
                    -- omnisharp
                    local sln_files = vim.fs.find(function(name, _)
                        return name:match('.*%.sln$')
                    end, { limit = math.huge, type = 'file', stop = '.' })

                    local sln_file = ''
                    if #sln_files > 0 then
                        vim.ui.select(sln_files, { prompt = 'Select solution' }, function(selection)
                            sln_file = selection
                        end)
                    end

                    lspconfig.omnisharp.setup({
                        root_dir = function()
                            return './'
                        end,
                        enable_roslyn_analyzers = true,
                        analyze_open_documents_only = false,
                        organize_imports_on_format = true,
                        cmd = { string.format('%s/%s', vim.fn.stdpath('data'), 'mason/packages/omnisharp/libexec/OmniSharp'), '-s', sln_file, '-z', '--hostPID', tostring(vim.fn.getpid()), '--languageserver', '--encoding', 'utf-8' },
                        on_new_config = function(config, _)
                            if config.enable_editorconfig_support then
                                table.insert(config.cmd, 'FormattingOptions:EnableEditorConfigSupport=true')
                            end

                            if config.organize_imports_on_format then
                                table.insert(config.cmd, 'FormattingOptions:OrganizeImports=true')
                            end

                            if config.enable_ms_build_load_projects_on_demand then
                                table.insert(config.cmd, 'MsBuild:LoadProjectsOnDemand=true')
                            end

                            if config.enable_roslyn_analyzers then
                                table.insert(config.cmd, 'RoslynExtensionsOptions:EnableAnalyzersSupport=true')
                            end

                            if config.enable_import_completion then
                                table.insert(config.cmd, 'RoslynExtensionsOptions:EnableImportCompletion=true')
                            end

                            if config.sdk_include_prereleases then
                                table.insert(config.cmd, 'Sdk:IncludePrereleases=true')
                            end

                            if config.analyze_open_documents_only then
                                table.insert(config.cmd, 'RoslynExtensionsOptions:AnalyzeOpenDocumentsOnly=true')
                            end

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
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, lsp_opts)
                    vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help, lsp_opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, lsp_opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, lsp_opts)
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, lsp_opts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, lsp_opts)
                    vim.keymap.set('n', '<leader>fm', function()
                        require('conform').format({ async = true, lsp_fallback = true, timeout_ms = 1000 })
                    end, opts)
                end
            })
        end
    },

}
