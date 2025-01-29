return {
    'folke/todo-comments.nvim',
    enabled = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('todo-comments').setup()
        vim.keymap.set('n', '<Leader>ft', ':TodoFzfLua<CR>', { desc = 'FZF: search TODOs' })
    end,
}
