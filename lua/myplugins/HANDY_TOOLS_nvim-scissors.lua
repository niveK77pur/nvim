return {
    'chrisgrieser/nvim-scissors',
    enabled = function()
        return vim.fn.has('nvim-0.10') == 1
    end,
    opts = {},
}
