return {
    'anuvyklack/fold-preview.nvim',
    dependencies = { 'anuvyklack/keymap-amend.nvim' },
    enabled = true,
    config = function()
        require('fold-preview').setup()
    end,
}
