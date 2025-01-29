local kopts = { noremap = true, silent = true }

return {
    'kevinhwang91/nvim-hlslens',
    enabled = false,
    keys = {
        {
            'n',
            [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
            unpack(kopts),
        },
        {
            'N',
            [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
            unpack(kopts),
        },
        { '*', [[*<Cmd>lua require('hlslens').start()<CR>]], unpack(kopts) },
        { '#', [[#<Cmd>lua require('hlslens').start()<CR>]], unpack(kopts) },
        { 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], unpack(kopts) },
        { 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], unpack(kopts) },
        { '<Leader>l', '<Cmd>noh<CR>', unpack(kopts) },
    },
    config = function()
        require('hlslens').setup()
    end,
}
