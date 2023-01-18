return { 'marko-cerovac/material.nvim', disable=true,
    config = function()
        vim.g.material_style = ({
            'darker',     -- 1
            'lighter',    -- 2
            'oceanic',    -- 3
            'palenight',  -- 4
            'deep ocean', -- 5
        })[4]
        vim.cmd 'colorscheme material'
    end
}
