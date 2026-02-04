return {
    'TheNoeTrevino/haunt.nvim',
    ---@class HauntConfig
    opts = {},
    init = function()
        local prefix = 'h'

        -- annotations
        vim.keymap.set('n', '<Leader>' .. prefix .. 'a', function()
            require('haunt.api').annotate()
        end, { desc = 'Annotate' })

        vim.keymap.set('n', '<Leader>' .. prefix .. 'd', function()
            require('haunt.api').delete()
        end, { desc = 'Delete bookmark' })

        vim.keymap.set('n', '<Leader>' .. prefix .. 'f', function()
            require('haunt.picker').show()
        end, { desc = 'Show Picker' })

        vim.keymap.set('n', '<Leader>' .. prefix .. '[', function()
            require('haunt.api').prev()
        end, { desc = 'Previous bookmark' })

        vim.keymap.set('n', '<Leader>' .. prefix .. ']', function()
            require('haunt.api').next()
        end, { desc = 'Next bookmark' })

        vim.keymap.set('n', '<Leader>' .. prefix .. prefix, function()
            vim.ui.select({
                'require("haunt.api").toggle_annotation()',
                'require("haunt.api").toggle_all_lines()',
                'require("haunt.api").clear_all()',
                'require("haunt.api").to_quickfix()',
                'require("haunt.api").to_quickfix({ current_buffer = true })',
                'require("haunt.api").yank_locations({ current_buffer = true })',
                'require("haunt.api").yank_locations()',
            }, {}, function(choice)
                vim.api.nvim_exec2('lua ' .. choice, {})
            end)
        end)
    end,
}
