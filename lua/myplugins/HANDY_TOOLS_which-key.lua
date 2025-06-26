return {
    'folke/which-key.nvim',
    enabled = true,
    event = 'VeryLazy',
    keys = {
        {
            '<leader>?',
            function()
                require('which-key').show({ global = false })
            end,
            desc = 'Buffer Local Keymaps (which-key)',
        },
    },
    opts = {
        delay = function(ctx)
            return ctx.plugin and 0 or 700
        end,
    },
}
