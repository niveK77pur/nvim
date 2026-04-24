vim.diagnostic.config({
    float = {
        source = 'if_many',
        focusable = false,
    },
    virtual_text = {
        source = 'if_many',
    },
    virtual_lines = {
        current_line = true,
    },
    severity_sort = true,
    signs = {
        text = {
            -- 'nf-fa' class
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        },
    },
})
