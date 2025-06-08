return {
    'folke/lazydev.nvim',
    enabled = function()
        return vim.fn.has('nvim-0.10') == 1
    end,
    ft = { 'lua' },
    opts = {
        library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
    },
}
