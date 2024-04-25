return {
    {
        'mfussenegger/nvim-lint',
        ft = { 'typescript', 'javascript', 'vue' },
        config = function(_, _)
            local lint = require('lint')
            lint.linters_by_ft = {
                typescript = { 'eslint' },
                javascript = { 'eslint' },
            }
            vim.api.nvim_create_autocmd(
                { 'InsertLeave', 'BufWritePost' },
                {
                    callback = function()
                        lint.try_lint()
                    end
                })
        end,
    }
}
