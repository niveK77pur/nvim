return {
    'NvChad/nvim-colorizer.lua',
    enabled = true,
    init = function()
        vim.cmd('set termguicolors')
    end,
    config = function()
        require('colorizer').setup({
            mode = ({ 'foreground', 'background', 'virtualtext' })[3],
        })
    end,
}
