return {
    'tiagovla/tokyodark.nvim',
    enabled = false,
    init = function()
        vim.g.tokyodark_transparent_background = false
        vim.g.tokyodark_enable_italic_comment = true
        vim.g.tokyodark_enable_italic = false
        vim.g.tokyodark_color_gamma = '1.0'
    end,
    config = function()
        vim.cmd('colorscheme tokyodark')
    end,
}
