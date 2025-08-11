local linters_by_ft = {
    sh = { 'shellcheck' },
    nix = { 'statix' },
}

return {
    'mfussenegger/nvim-lint',
    enabled = true,
    ft = vim.tbl_keys(linters_by_ft),
    config = function()
        local lint = require('lint')

        lint.linters_by_ft = linters_by_ft
        vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}

-- vim: fdm=marker
