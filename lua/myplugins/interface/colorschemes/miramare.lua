return { 'franbach/miramare', disable=true,
    setup = function()
        vim.g.miramare_enable_italic = 1
    end,
    config = function()
        vim.cmd 'colorscheme miramare'
    end,
}
