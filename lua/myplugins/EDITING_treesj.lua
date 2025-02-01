return {
    'Wansmer/treesj',
    enabled = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
    opts = {
        use_default_keymaps = false,
    },
}
