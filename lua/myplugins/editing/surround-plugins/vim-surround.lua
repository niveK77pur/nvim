return { 'tpope/vim-surround',
    enabled = false,
    config = function()
        local map = vim.keymap.set

        vim.g.surround_no_mappings = true
        map('n', 'ds', '<Plug>Dsurround')
        map('n', 'cs', '<Plug>Csurround')
    end
}
