return {
    'Wansmer/treesj',
    enabled = true,
    keys = {
        {
            '<Leader>tm',
            function()
                require('treesj').toggle()
            end,
            desc = 'treesj: toggle',
        },
        {
            '<Leader>tj',
            function()
                require('treesj').join()
            end,
            desc = 'treesj: join',
        },
        {
            '<Leader>ts',
            function()
                require('treesj').split()
            end,
            desc = 'treesj: split',
        },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
        use_default_keymaps = false,
    },
}
