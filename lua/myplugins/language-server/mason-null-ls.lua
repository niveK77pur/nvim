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

        local column_width = tonumber(vim.wo.colorcolumn) or 80

        require("mason").setup()
        mason_null_ls.setup({
            ensure_installed = { --  {{{
                -- Opt to list sources here, when available in mason.
                "stylua",
            }, --  }}}
            handlers = { --  {{{
                function(source_name, methods)
                    -- all sources with no handler get passed here
                    require("mason-null-ls.automatic_setup")(
                        source_name,
                        methods
                    )
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
                rustfmt = function(source_name, methods) --  {{{
                    null_ls.register(null_ls.builtins.formatting.rustfmt.with({
                        extra_args = {
                            "--config"
                            .. " "
                            .. "max_width="
                            .. column_width
                            .. ","
                            .. "comment_width="
                            .. column_width
                            .. ","
                            .. "wrap_comments=true"
                            .. ","
                            .. "format_code_in_doc_comments=true",
                        },
                    }))
                end, --  }}}
            }, --  }}}
            automatic_installation = true,
            automatic_setup = true,
        })
        null_ls.setup({
            sources = { --  {{{
                -- Anything not supported by mason.
            }, --  }}}
            -- default_timeout = -1,
        })
    end,
}

-- vim: fdm=marker
