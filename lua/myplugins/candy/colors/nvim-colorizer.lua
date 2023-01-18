return { 'NvChad/nvim-colorizer.lua',
    config = function()
        require'colorizer'.setup{
            mode = ({'foreground','background', 'virtualtext'})[3],
        }
    end
}
