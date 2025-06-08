return {
    'folke/neodev.nvim',
    enabled = function()
        -- only enable when lazydev.nvim is not enabled (probably using an
        -- older nvim version here)
        return require('lazy.core.config').plugins['lazydev.nvim'] == nil
    end,
    cond = vim.version.lt(vim.version(), { 0, 10, 0 }),
    ft = 'lua',
    opts = {},
}
