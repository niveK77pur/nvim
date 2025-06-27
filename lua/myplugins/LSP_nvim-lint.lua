local linters = {
    sh = { 'shellcheck' },
    nix = { 'statix' },
}

return {
    'mfussenegger/nvim-lint',
    enabled = true,
    ft = vim.tbl_keys(linters),
    config = function()
        local lint = require('lint')

        lint.linters_by_ft = linters
        vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}

-- vim: fdm=marker
