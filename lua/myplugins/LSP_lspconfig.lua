return {
    'neovim/nvim-lspconfig',
    enabled = vim.version.ge(vim.version(), { 0, 11, 0 }),
    config = function()
        -- enable all LSPs for which there are files in lsp/
        local lsp_dir = vim.fn.stdpath('config') .. '/lsp'
        local original_package_path = package.path
        package.path = lsp_dir .. '/?.lua' -- modify for 'require' later
        for _, file in ipairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
            local lspname = file:match(lsp_dir .. '/(.*)%.lua')
            if (lspname == nil) or (vim.fn.empty(lspname) == 1) then
                goto continue
            end

            vim.lsp.enable(lspname)
            vim.lsp.config(lspname, require(lspname))

            ::continue::
        end
        package.path = original_package_path
    end,
}
