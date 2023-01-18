return { 'jiangmiao/auto-pairs', disable = false,
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
        -- Default: <M-p>
        vim.g.AutoPairsShortcutToggle = "<Leader><M-p>"
        -- Default: <M-b>
        -- vim.g.AutoPairsBackInsert = "<Leader><M-b>"
    end,
}
