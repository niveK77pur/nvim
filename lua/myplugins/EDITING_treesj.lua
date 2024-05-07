local keys = {
    toggle = '<Leader>tm',
    join = '<Leader>tj',
    split = '<Leader>ts',
}
return {
    'Wansmer/treesj',
    enabled = true,
    keys = vim.tbl_values(keys),
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
        use_default_keymaps = false,
    },
    config = function()
        local treesj = require('treesj')
        vim.keymap.set('n', keys.toggle, treesj.toggle, {
            desc = 'treesj - toggle',
        })
        vim.keymap.set('n', keys.join, treesj.join, {
            desc = 'treesj - join',
        })
        vim.keymap.set('n', keys.split, treesj.split, {
            desc = 'treesj - split',
        })
    end,
}
