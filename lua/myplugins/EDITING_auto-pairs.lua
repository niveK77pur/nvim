return {
    'LunarWatcher/auto-pairs',
    enabled = true,
    config = function()
        local augroup =
            vim.api.nvim_create_augroup('AutoPairsVim', { clear = false })
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

        -- see ':h autopairs-shortcut' and ':h autopairs-options-contents'
        vim.g.AutoPairsMoveCharater = ''
        vim.g.AutoPairsPrefix = '<Leader><C-p>'

        -- backspace behaviour
        vim.g.AutoPairsMapBS = 1
        vim.g.AutoPairsBSAfter = 1
        vim.g.AutoPairsBSIn = 1
        vim.g.AutoPairsMultilineBackspace = 1
    end,
}
