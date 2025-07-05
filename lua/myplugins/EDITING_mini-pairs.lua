return {
    'echasnovski/mini.pairs',
    enable = true,
    version = false,
    event = 'InsertEnter',
    opts = {},
    init = function()
        local augroup_mini_pairs = vim.api.nvim_create_augroup('mini_pairs', {})
        vim.api.nvim_create_autocmd({ 'FileType' }, {
            group = augroup_mini_pairs,
            pattern = { 'lilypond' },
            desc = 'Set which LilyPond characters should not be auto-paired.',
            callback = function()
                local pairs = require('mini.pairs')
                pairs.unmap('i', '(', '()')
                pairs.unmap('i', ')', '()')
                pairs.unmap('i', '[', '[]')
                pairs.unmap('i', ']', '[]')
                pairs.unmap('i', "'", "''")
            end,
        })
    end,
}
