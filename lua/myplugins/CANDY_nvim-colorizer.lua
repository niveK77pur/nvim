return {
    'NvChad/nvim-colorizer.lua',
    enabled = true,
    config = function()
        require('colorizer').setup({
            mode = ({ 'foreground', 'background', 'virtualtext' })[3],
        })
    end,
}
