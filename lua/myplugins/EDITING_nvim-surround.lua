return {
    'kylechui/nvim-surround',
    enabled = true,
    config = function()
        require('nvim-surround').setup({
            keymaps = {
                visual = '<Leader>s',
            },
            aliases = {
                ['a'] = false,
                ['b'] = false,
                ['B'] = false,
                ['r'] = false,
                ['s'] = false,
            },
            -- move_cursor = false,
        })

        local augroup_nvimsurround =
            vim.api.nvim_create_augroup('nvimsurround', {})
        vim.api.nvim_create_autocmd({ 'FileType' }, {
            group = augroup_nvimsurround,
            pattern = { 'lua' },
            desc = 'nvim-surround config for lua filetype',
            callback = function()
                require('nvim-surround').buffer_setup({
                    surrounds = {
                        ['s'] = {
                            add = { '[[', ']]' },
                            find = '%[(=*)%[.-%]%1%]',
                            -- find = function()
                            --     local config = require("nvim-surround.config")
                            --     -- return config.get_selection({ motion = '2a[' })
                            --     return config.get_selection({ node = 'string' })
                            -- end,
                            delete = '^(%[=*%[)().-(%]=*%])()$',
                            -- delete = '^(%[%[)().*(%]%])()$',
                            change = { target = '^(%[=*%[)().-(%]=*%])()$' },
                        },
                    },
                })
            end,
        })
    end,
}
