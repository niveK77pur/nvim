local lspconfig_filetypes = vim.iter(vim.api.nvim_get_runtime_file('lsp/ltex.lua', true))
    :filter(function(path)
        return path:match('nvim%-lspconfig')
    end)
    :map(dofile)
    :map(function(config)
        return config.filetypes
    end)
    :totable()

return {
    settings = {
        ltex = {
            language = 'en-GB',
        },
    },
    filetypes = vim.iter({
        lspconfig_filetypes,
        {
            'asciidoc',
            'jjdescription',
        },
    })
        :flatten(math.huge)
        :totable(),
}
