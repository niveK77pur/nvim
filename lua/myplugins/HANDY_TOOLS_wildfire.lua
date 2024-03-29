return {
    'sustech-data/wildfire.nvim',
    enabled = true,
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('wildfire').setup({
            keymaps = {
                init_selection = '<CR>',
                node_incremental = '<CR>',
                node_decremental = '<BS>',
            },
        })
    end,
}
