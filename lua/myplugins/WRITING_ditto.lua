local filetypes = { 'tex', 'latex', 'text', 'markdown', 'asciidoc' }

return {
    'dbmrq/vim-ditto',
    enabled = true,
    ft = filetypes,
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
        local augroup_Ditto = vim.api.nvim_create_augroup('Ditto', {})
        vim.api.nvim_create_autocmd({ 'FileType' }, {
            group = augroup_Ditto,
            pattern = filetypes,
            desc = 'Activate Ditto on filetypes',
            callback = function()
                vim.cmd([[DittoOn]])
            end,
        })
    end,
}
