local keys = {
    ['<Leader>tl'] = 'swap_with_right',
    ['<Leader>th'] = 'swap_with_left',
    ['<Leader>tL'] = 'swap_with_right_with_opp',
    ['<Leader>tH'] = 'swap_with_left_with_opp',
}

return {
    'Wansmer/sibling-swap.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = vim.tbl_keys(keys),
    opts = {
        use_default_keymaps = true,
        keymaps = keys,
    },
}
