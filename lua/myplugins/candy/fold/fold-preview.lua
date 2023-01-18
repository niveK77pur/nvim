return { 'anuvyklack/fold-preview.nvim', disable=false,
    requires = 'anuvyklack/keymap-amend.nvim',
    config = function()
        require('fold-preview').setup()
    end
}
