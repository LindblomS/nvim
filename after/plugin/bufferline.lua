vim.opt.termguicolors = true
local bufferline = require('bufferline')
bufferline.setup {
    options = {
        diagnostics = 'nvim_lsp',
        offsets = {
            {
                filetype = 'NvimTree',
                text = 'explorer',
                text_align = 'left',
                separator = true
            }
        }
    }
}


