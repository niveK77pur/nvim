local linters_by_ft = {
    sh = { 'shellcheck' },
    nix = { 'statix' },
    lua = { 'luacheck', 'selene' },
    python = {},
    markdown = {},
}

for ft, _ in pairs(linters_by_ft) do
    -- Add 'typos' linter everywhere
    table.insert(linters_by_ft[ft], 'typos')
end

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
