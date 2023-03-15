return { 'embark-theme/vim',
    name = 'embark',
    init = function ()
        vim.g.embark_terminal_italics = 1
    end,
    config = function()
        vim.cmd('colorscheme embark')
    end
}
