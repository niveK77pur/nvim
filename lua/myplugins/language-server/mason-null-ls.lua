return {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local null_ls = require("null-ls")
        local mason_null_ls = require("mason-null-ls")

        local column_width = 80

        require("mason").setup()
        mason_null_ls.setup({
            --  {{{
            ensure_installed = {
                -- Opt to list sources here, when available in mason.
                "stylua",
            },
            automatic_installation = true,
            automatic_setup = true,
        }) --  }}}
        null_ls.setup({
            --  {{{
            sources = {
                -- Anything not supported by mason.
            },
            -- default_timeout = -1,
        }) --  }}}

        mason_null_ls.setup_handlers({
            function(source_name, methods)
                -- all sources with no handler get passed here
                require("mason-null-ls.automatic_setup")(source_name, methods)
            end,
            stylua = function(source_name, methods) --  {{{
                null_ls.register(null_ls.builtins.formatting.stylua.with({
                    extra_args = {
                        "--column-width",
                        column_width,
                        "--indent-type",
                        "Spaces",
                    },
                }))
            end, --  }}}
        })
    end,
}

-- vim: fdm=marker
