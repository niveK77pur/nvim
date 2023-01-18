return { 'NvChad/nvim-colorizer.lua', disable=false,
    config = function()
        require'colorizer'.setup{
            mode = ({'foreground','background', 'virtualtext'})[3],
        }
    end
}
