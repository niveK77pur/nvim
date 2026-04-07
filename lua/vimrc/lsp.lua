-- LSP completion
-- See `:h lsp-completion`
local augroup_lsp = vim.api.nvim_create_augroup('lsp', {})
vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup_lsp,
    callback = function(args)
        local client_id = args.data.client_id
        if not client_id then
            return
        end
        local client = vim.lsp.get_client_by_id(client_id)
        if client and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client_id, args.buf, {
                autotrigger = true,
            })
        end
    end,
})
