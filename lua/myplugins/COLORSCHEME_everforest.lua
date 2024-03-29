return {
    'sainnhe/everforest',
    enabled = false,
    init = function()
        vim.g.everforest_transparent_background = 1
        -- treesitter highlighting seem to interfere with everforest
        pcall(vim.cmd, 'TSDisable highlight')
    end,
    config = function()
        vim.cmd([[colorscheme everforest]])
    end,
}
