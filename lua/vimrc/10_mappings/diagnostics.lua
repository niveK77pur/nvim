vim.keymap.set('n', 'gdt', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    if vim.diagnostic.is_enabled() then
        vim.notify('Diagnostics enabled')
    else
        vim.notify('Diagnostics disabled')
    end
end, { desc = 'Toggle diagnostics', noremap = true })

---@type vim.diagnostic.Opts?
local diagnostic_config
vim.keymap.set('n', 'gdv', function()
    local dc = vim.diagnostic.config()
    local diagnostic_virtual_enabled = dc and (dc.virtual_lines or dc.virtual_text)
    if diagnostic_virtual_enabled then
        diagnostic_config = dc
        vim.diagnostic.config(vim.tbl_extend('force', diagnostic_config, {
            virtual_text = false,
            virtual_lines = false,
        }))
        vim.notify('Diagnostic virtual text/lines disabled')
    else
        if diagnostic_config == nil then
            return
        end
        vim.diagnostic.config(vim.tbl_extend('force', dc, {
            virtual_text = diagnostic_config.virtual_text,
            virtual_lines = diagnostic_config.virtual_lines,
        }))
        vim.notify('Diagnostic virtual text/lines config restored')
    end
end, { desc = 'Toggle virtual text/lines only' })

vim.keymap.set('n', 'gdq', vim.diagnostic.setqflist, { desc = 'Open diagnostics in quickfix' })
