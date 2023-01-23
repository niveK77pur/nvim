return { 'embark-theme/vim',
    as = 'embark',
    setup = function ()
        vim.g.embark_terminal_italics = 1
    end,
    config = function()
        vim.cmd('colorscheme embark')
    end
}
