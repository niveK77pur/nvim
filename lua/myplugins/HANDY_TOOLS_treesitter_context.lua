return {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    enabled = true,
    config = function()
        require('treesitter-context').setup({
            separator = '━',
        })

        local augroup_nvim_treesitter_context = vim.api.nvim_create_augroup('nvim_treesitter_context', {})
        vim.api.nvim_create_autocmd({ 'FileType' }, {
            group = augroup_nvim_treesitter_context,
            pattern = { 'nix' },
            desc = 'Disable treesitter context plugin for given FileTypes',
            callback = function()
                vim.cmd([[TSContext disable]])
            end,
        })
    end,
}
