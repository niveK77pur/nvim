return { 'subnut/nvim-ghost.nvim',
    -- build = ':call nvim_ghost#installer#install()',
    cmd = { 'GhostTextEnable' },
    init = function ()
        -- vim.g.nvim_ghost_super_quiet = 1
        vim.g.nvim_ghost_disabled = 1
    end,
    config = function()

        -- All autocommands should be in 'nvim_ghost_user_autocommands' group
        local augroup_nvim_ghost_user_autocommands = vim.api.nvim_create_augroup('nvim_ghost_user_autocommands', {})
        local function addWebsiteSettings(opts) --  {{{
            vim.api.nvim_create_autocmd({ 'User' }, {
                group = augroup_nvim_ghost_user_autocommands,
                pattern = opts.pattern,
                desc = opts.desc,
                callback = opts.callback,
            })
        end --  }}}

        addWebsiteSettings {
            pattern = { 'www.overleaf.com' },
            desc = "nvim-ghost: set Overleaf settings",
            callback = function() --  {{{
                vim.opt.filetype = 'tex'
                vim.opt.foldenable = false
                vim.opt.wrap = true

                -- avoid being overwriten by ftplugin
                vim.schedule(function()
                    vim.opt.textwidth = 0
                    vim.opt.tabstop = 4
                    vim.opt.shiftwidth = 0
                end)

                -- taken from markdown ftplugin
                for _,key in pairs{ 'j', 'k', '0', '$' } do
                    vim.keymap.set('n', key, 'g'..key, { desc = string.format('remap %s for better text editing', key) })
                end
            end --  }}}
        }

        addWebsiteSettings {
            pattern = { 'github.com' },
            desc = "nvim-ghost: set GitHub settings",
            callback = function()
                vim.opt.filetype = 'markdown'
            end
        }

    end,
}
