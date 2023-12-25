return {
    'jcdickinson/codeium.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'hrsh7th/nvim-cmp',
    },
    enabled = true,
    config = function()
        require('codeium').setup({})
    end,
}
