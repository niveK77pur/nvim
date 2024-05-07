return {
    'AndrewRadev/splitjoin.vim',
    enabled = true,
    keys = {
        'gS',
        'gJ',
    },
    config = function()
        vim.cmd([[do FileType]])
    end,
}
