return {
    'ggandor/leap.nvim',
    enabled = true,
    config = function()
        require('leap').set_default_mappings()
        vim.schedule(function()
            vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Conceal' })
        end)

        require('leap').opts.equivalence_classes = {
            ' \t\r\n',
            '([{',
            ')]}',
            [['"`]],
        }

        -- treesitter integration
        vim.keymap.set({ 'x', 'o' }, 'S', function()
            require('leap.treesitter').select({
                opts = require('leap.user').with_traversal_keys('R', 'r'),
            })
        end)
    end,
}
