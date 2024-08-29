return {
    'stevearc/oil.nvim',
    opts = {
        buf_options = {
            bufhidden = true,
        },
        win_options = {
            wrap = true,
        },
        skip_confirm_for_simple_edits = true,
    },
    config = function()
        vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>")
    end
}
