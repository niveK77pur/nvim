return { 'hrsh7th/nvim-cmp',
    requires = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-emoji',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-omni',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'neovim/nvim-lspconfig',
        'onsails/lspkind.nvim',
        'quangnguyen30192/cmp-nvim-ultisnips',
        -- 'hrsh7th/cmp-cmdline',
        -- 'hrsh7th/cmp-path',
        -- 'saadparwaiz1/cmp_luasnip',
    },
    config = function()
        local cmp = require 'cmp'
        local lspkind = require('lspkind')

        cmp.setup { -- {{{
            formatting = {
                format = lspkind.cmp_format({
                    -- mode = 'symbol',
                }),
            },
            view = {
                entries = { name = 'custom', selection_order = 'near_cursor' },
            },
            snippet = {
                expand = function(args)
                    vim.fn["UltiSnips#Anon"](args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-y>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),
            }),
            sources = cmp.config.sources(
                {
                    { name = 'nvim_lsp' },
                    { name = 'ultisnips' },
                    { name = 'nvim_lsp_signature_help' },
                },
                {
                    -- { name = 'path', option = { trailing_slash = true } },
                    { name = 'buffer' },
                    { name = 'emoji', option = { insert = true } },
                }
            ),
        } -- }}}

        -- -- `/` cmdline setup.
        -- cmp.setup.cmdline({ '/', '?' }, {
        --     mapping = cmp.mapping.preset.cmdline(),
        --     sources = {
        --         { name = 'buffer' }
        --     }
        -- })

        cmp.setup.filetype('tex', { -- {{{
            sources = cmp.config.sources(
                {
                    { name = 'nvim_lsp', },
                    { name = 'ultisnips' },
                },
                {
                    { name = 'omni' },
                }
            )
        }) -- }}}

        cmp.setup.filetype('lilypond', { -- {{{
            sources = (
            {
                { name = 'dictionary', keyword_length = 4 },
                { name = 'ultisnips' },
            }
            )
        }) -- }}}

    end,
}

-- vim: fdm=marker
