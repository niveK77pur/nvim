return {
    'dbmrq/vim-ditto',
    enabled = true,
    ft = { 'tex', 'latex', 'text', 'markdown' },
    keys = {
        {
            '<Leader>dt',
            '<Plug>ToggleDitto',
            desc = 'ditto: Turn Ditto on and off',
        },
        {
            '<Leader>dn',
            '<Plug>DittoNext',
            desc = 'ditto: Jump to the next word',
        },
        {
            '<Leader>dp',
            '<Plug>DittoPrev',
            desc = 'ditto: Jump to the previous word',
        },
        {
            '<Leader>d+',
            '<Plug>DittoGood',
            desc = 'ditto: Ignore the word under the cursor',
        },
        {
            '<Leader>d-',
            '<Plug>DittoBad',
            desc = 'ditto: Stop ignoring the word under the cursor',
        },
        {
            '<Leader>d>',
            '<Plug>DittoMore',
            desc = 'ditto: Show the next matches',
        },
        {
            '<Leader>d<',
            '<Plug>DittoLess',
            desc = 'ditto: Show the previous matches',
        },
    },
    config = function()
        vim.cmd([[
            augroup ditto
            autocmd!
            au FileType markdown,text,       tex,latex DittoOn
            augroup END
        ]])
    end,
}
