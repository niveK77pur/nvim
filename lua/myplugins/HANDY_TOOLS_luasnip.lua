return {
    'L3MON4D3/LuaSnip',
    enabled = true,
    version = 'v2.*',
    -- install jsregexp (optional!).
    build = 'make install_jsregexp',
    event = { 'InsertEnter', [[ModeChanged *:[vV\x16]*]] },
    init = function()
        local augroup_luasnip = vim.api.nvim_create_augroup('luasnip', {})
        vim.api.nvim_create_autocmd({ 'BufEnter' }, {
            group = augroup_luasnip,
            pattern = { vim.fn.stdpath('config') .. '/lua/luasnip/*.lua' },
            desc = 'Disable diagnostics in LuaSnip files',
            callback = function()
                vim.diagnostic.enable(false)
            end,
        })
    end,
    config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
        require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })
        require('luasnip.loaders.from_lua').load({ paths = { vim.fn.stdpath('config') .. '/lua/luasnip' } })

        local ls = require('luasnip')
        ls.setup({
            exit_roots = false,
            cut_selection_keys = '<tab>',
        })

        vim.keymap.set({ 'i', 's' }, '<C-j>', function()
            ls.expand_or_jump()
        end, { desc = 'Expand or jump in the snippet', silent = true })
        vim.keymap.set({ 'i', 's' }, '<C-M-j>', function()
            ls.jump(-1)
        end, { desc = 'Jump backward in the snippet', silent = true })
        vim.keymap.set({ 'i', 's' }, '<C-l>', function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { desc = 'Cycle through the choices in a choice node', silent = true })
        vim.keymap.set({ 'i', 's' }, '<C-M-l>', function()
            require('luasnip.extras.select_choice')()
        end, { desc = 'Select choice for a choice node', silent = true })

        vim.keymap.set({ 'n' }, '<Leader>vs', function()
            require('luasnip.loaders').edit_snippet_files()
        end, { desc = 'LuaSnip: Edit snippets' })
    end,
}
