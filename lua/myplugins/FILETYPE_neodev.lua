return {
    'folke/neodev.nvim',
    enabled = true,
    cond = vim.version.lt(vim.version(), { 0, 10, 0 }),
    ft = 'lua',
    opts = {},
}
