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

        -- remote actions
        vim.keymap.set({ 'n', 'x', 'o' }, 'gs', function()
            require('leap.remote').action()
        end)
        -- automatic paste after remote yanking
        vim.api.nvim_create_autocmd('User', {
            pattern = 'RemoteOperationDone',
            group = vim.api.nvim_create_augroup('LeapRemote', {}),
            callback = function(event)
                -- Do not paste if some special register was in use.
                if vim.v.operator == 'y' and event.data.register == '"' then
                    vim.cmd('normal! p')
                end
            end,
        })
    end,
}
