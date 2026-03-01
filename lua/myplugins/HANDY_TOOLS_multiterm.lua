return {
    'imranzero/multiterm.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        keymaps = {
            toggle = '<F12>',
            list = '<leader><F12>',
        },
        vim.keymap.set('n', '<Leader>j', '<CMD>Multiterm jjui<CR>'),
    },
}
