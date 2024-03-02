return {
    'cbochs/grapple.nvim',
    dependencies = {
        { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    config = function()
        local grapple = require('grapple')

        vim.keymap.set('n', '<leader>m', grapple.toggle)
        vim.keymap.set('n', '<leader>M', grapple.toggle_tags)
        vim.keymap.set('n', '<leader><A-m>', grapple.toggle_scopes)
        vim.keymap.set('n', '<leader><C-m>', grapple.toggle_loaded)

        grapple.define_scope({
            name = 'nvim',
            desc = 'Neovim config directory',
            cache = { event = 'DirChanged' },
            resolver = function()
                local path = vim.fn.stdpath('config')
                local id = path
                return id, path, nil
            end,
        })
    end,
}
