return { 'embark-theme/vim', disable=true,
    as = 'embark',
    setup = function ()
        vim.g.embark_terminal_italics = 1
    end,
    config = function()
        vim.cmd('colorscheme embark')
    end
}
