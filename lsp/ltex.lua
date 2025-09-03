return {
    settings = {
        ltex = {
            language = 'en-GB',
        },
    },
    filetypes = vim.iter({
        require('lspconfig').ltex.config_def.default_config.filetypes,
        {
            'asciidoc',
            'jjdescription',
        },
    })
        :flatten()
        :totable(),
}
