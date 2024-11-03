return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            defaults = {
                layout_strategy = "vertical",
                layout_config = {
                    width = 0.9,
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--trim"
                },
                preview = false,
                path_display = {
                    "filename_first",
                    "truncate"
                },
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    },
                    n = {
                        ["d"] = "delete_buffer",
                        ["a"] = "add_selection",
                        ["r"] = "remove_selection",
                        ["q"] = "send_selected_to_qflist",
                    },
                },
            },
            pickers = {
                live_grep = {
                    preview = true,
                },
                lsp_document_symbols = {
                    preview = true,
                },
                lsp_references = {
                    preview = true,
                }
            },
        },
        keys = {
            { "<leader>ff" },
            { "<leader>fw" },
        },
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            local builtin = require("telescope.builtin")
            local set = vim.keymap.set
            set("n", "gr", builtin.lsp_references, { desc = "Go to reference" })
            set("n", "gs", builtin.lsp_document_symbols, { desc = "Go to document symbol" })
            set("n", "gd", builtin.lsp_definitions, { desc = "Go to definition" })
            set("n", "gD", builtin.lsp_type_definitions, { desc = "Go to type definition" })
            set("n", "gi", builtin.lsp_implementations, { desc = "Go to implementation" })
            set("n", "<leader>ff", builtin.find_files, { desc = "Find files, respects .gitignore" })
            set("n", "<leader>faf", function()
                builtin.find_files({ no_ignore = true })
            end, { desc = "Find all files" })
            set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })
            set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
            set("n", "<leader>fw", builtin.live_grep, { desc = "Find word" })
            set({ "n", "v" }, "<leader>fW", builtin.grep_string, { desc = "Find word under cursor or selection" })
        end,
    },
}
