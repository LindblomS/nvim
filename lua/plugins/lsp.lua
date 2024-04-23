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
                    'eslint_lsp',
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

            lspconfig.eslint.setup({
                on_attach = function(_, bufnr)
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        command = 'EslintFixAll',
                    })
                end
            })

            vim.api.nvim_create_user_command('OmniSharp',
                function()
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
                        cmd = {
                            string.format('%s/%s', vim.fn.stdpath('data'), 'mason/packages/omnisharp/libexec/OmniSharp'),
                            '-s',
                            sln_file,
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
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, lsp_opts)
                    vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help, lsp_opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, lsp_opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, lsp_opts)
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, lsp_opts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, lsp_opts)
                    vim.keymap.set('n', '<leader>fm', function() vim.lsp.buf.format { async = true } end, lsp_opts)
                end
            })
        end
    },
}
