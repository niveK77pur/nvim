return {
    'jinh0/eyeliner.nvim',
    enabled = true,
    keys = { 'f', 'F' },
    config = function()
        require('eyeliner').setup({
            highlight_on_key = true,
            dim = true,
        })
    end,
}
