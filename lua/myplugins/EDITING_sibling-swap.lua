return {
    'Wansmer/sibling-swap.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    keys = {
        {
            '<Leader>tl',
            function()
                require('sibling-swap').swap_with_right()
            end,
            desc = 'sibling-swap: swap_with_right',
        },
        {
            '<Leader>th',
            function()
                require('sibling-swap').swap_with_left()
            end,
            desc = 'sibling-swap: swap_with_left',
        },
        {
            '<Leader>tL',
            function()
                require('sibling-swap').swap_with_right_with_opp()
            end,
            desc = 'sibling-swap: swap_with_right_with_opp',
        },
        {
            '<Leader>tH',
            function()
                require('sibling-swap').swap_with_left_with_opp()
            end,
            desc = 'sibling-swap: swap_with_left_with_opp',
        },
    },
    opts = {
        use_default_keymaps = false,
    },
}
