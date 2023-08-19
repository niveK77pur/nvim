return {
    'sustech-data/wildfire.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('wildfire').setup({
            -- surrounds = {
            --     { '(', ')' },
            --     { '{', '}' },
            --     { '<', '>' },
            --     { '[', ']' },
            -- },
            keymaps = {
                init_selection = '<CR>',
                node_incremental = '<CR>',
                node_decremental = '<BS>',
            },
        })

        local augroup_revert_cr = vim.api.nvim_create_augroup('revert_cr', {})

        vim.api.nvim_create_autocmd({ 'FileType' }, {
            group = augroup_revert_cr,
            pattern = { 'qf' },
            desc = "Revert wildfire's <CR> on filetypes",
            callback = function()
                vim.cmd('noremap <CR> <CR>')
            end,
        })
    end,
}
