return { 'LunarWatcher/auto-pairs',
    enabled = true,
    config = function()
        local augroup = vim.api.nvim_create_augroup('AutoPairsVim', { clear = false })
        vim.api.nvim_create_autocmd('FileType', {
            group = augroup,
            pattern = { 'lilypond' },
            callback = function()
                vim.b.AutoPairs = {
                    ['{'] = '}',
                    ['"'] = '"',
                    ['`'] = '`',
                }
            end,
            desc = 'Set which LilyPond characters should be auto-paired.',
        })
        vim.api.nvim_create_autocmd('FileType', {
            group = augroup,
            pattern = { 'vim' },
            callback = function()
                vim.b.AutoPairs = {
                    ['('] = ')',
                    ['['] = ']',
                    ['{'] = '}',
                    ["'"] = "'",
                    ['`'] = '`',
                }
            end,
            desc = 'Set which VIM characters should be auto-paired.',
        })
        -- see ':h autopairs-shortcut' and ':h autopairs-options-contents'
        vim.g.AutoPairsMoveCharater = ''
        vim.g.AutoPairsPrefix = '<C-a>'
    end,
}
