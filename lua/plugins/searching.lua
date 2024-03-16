return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            defaults = {
                layout_strategy = 'horizontal',
                layout_config = {
                    width = 0.9,
                },
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case',
                    '--trim'
                },
            },
        },
        config = function(_, opts)
            require('telescope').setup(opts)
            local builtin = require('telescope.builtin')
            local set = vim.keymap.set
            set('n', '<leader>ff', builtin.find_files)
            set('n', 'gr', builtin.lsp_references)
            set('n', 'gs', builtin.lsp_document_symbols)
            set('n', 'gd', builtin.lsp_definitions)
            set('n', 'gD', builtin.lsp_type_definitions)
            set('n', 'gi', builtin.lsp_implementations)
            set('n', '<leader>d', builtin.diagnostics)
            set('n', '<leader>fb', builtin.buffers)
            set('n', '<leader>fw', builtin.live_grep)
            set('n', '<leader>gc', builtin.git_bcommits)
        end
    },
}
