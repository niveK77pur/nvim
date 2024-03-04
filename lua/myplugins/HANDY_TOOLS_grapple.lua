local function notify(msg, level)
    if level == nil then
        level = vim.log.levels.INFO
    end
    vim.notify(msg, level, { group = 'grapple.nvim', title = 'grapple.nvim' })
end

return {
    'cbochs/grapple.nvim',
    dependencies = {
        { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    config = function()
        local grapple = require('grapple')

        vim.keymap.set('n', '<leader>m', function()
            -- manually implement toggle to include notifications
            if grapple.exists() then
                notify('Removing tag')
                grapple.untag()
            else
                notify('Adding tag')
                grapple.tag()
            end
        end)
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
