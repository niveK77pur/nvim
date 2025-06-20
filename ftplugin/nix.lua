vim.o.tabstop = 2

do
    local preferred_ls = 'nil_ls'
    vim.keymap.set('n', 'grn', function()
        vim.lsp.buf.rename(nil, {
            filter = function(client)
                local client_names = vim.tbl_map(
                    function(c)
                        return c.name
                    end,
                    vim.lsp.get_clients({
                        bufnr = vim.api.nvim_get_current_buf(),
                    })
                )
                if not vim.tbl_contains(client_names, preferred_ls) then
                    return true
                end
                return client.name == preferred_ls
            end,
        })
    end, { desc = 'Override default lsp rename to select client' })
end
