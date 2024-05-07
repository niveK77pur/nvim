local keys = {
    ['<Leader>n'] = 'swap_with_right',
    ['<Leader>N'] = 'swap_with_left',
    ['<Leader>t.'] = 'swap_with_right_with_opp',
    ['<Leader>t,'] = 'swap_with_left_with_opp',
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
