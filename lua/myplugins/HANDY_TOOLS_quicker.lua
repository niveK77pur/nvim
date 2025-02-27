return {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
        keys = {
            {
                'o',
                function()
                    require('quicker').expand({ before = 2, after = 2 })
                end,
                desc = 'quicker.nvim: Expand quickfix context',
            },
            {
                'O',
                function()
                    require('quicker').collapse()
                end,
                desc = 'quicker.nvim: Collapse quickfix context',
            },
            {
                '<C-R>',
                function()
                    require('quicker').refresh()
                end,
                desc = 'quicker.nvim: Refresh quickfist with buffer contents',
            },
        },
    },
}
