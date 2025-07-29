local function notify(msg, level)
    if level == nil then
        level = vim.log.levels.INFO
    end
    vim.notify(msg, level, { group = 'grapple.nvim', title = 'grapple.nvim' })
end

return {
    'cbochs/grapple.nvim',
    enabled = true,
    dependencies = {
        { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    keys = {
        {
            '<leader>m',
            function()
                local grapple = require('grapple')
                -- manually implement toggle to include notifications
                if grapple.exists() then
                    notify('Removing tag')
                    grapple.untag()
                else
                    notify('Adding tag')
                    grapple.tag()
                end
            end,
        },
        {
            '<leader>M',
            function()
                require('grapple').toggle_tags()
            end,
        },
        {
            '<leader><A-m>',
            function()
                require('grapple').toggle_scopes()
            end,
        },
        {
            '<leader><C-m>',
            function()
                require('grapple').toggle_loaded()
            end,
        },
    },
    config = function()
        local grapple = require('grapple')

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
