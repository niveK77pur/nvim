return {
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    build = function()
        require('nvim-treesitter.install').update({ with_sync = true })
        -- vim.cmd([[TSUpdate]])
    end,
    config = function()
        local parser_config =
            require('nvim-treesitter.parsers').get_parser_configs()
        ---@diagnostic disable-next-line: missing-fields
        require('nvim-treesitter.configs').setup({ --  {{{1
            -- A list of parser names, or "all"
            -- ensure_installed = { "c", "lua", "rust" },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,
            -- Automatically install missing parsers when entering buffer
            auto_install = true,
            -- List of parsers to ignore installing (for "all")
            -- ignore_install = { "javascript" },

            --If you need to change the installation directory of the parsers (see -> Advanced Setup)
            -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

            highlight = {
                enable = true,
                -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is the name of the parser)
                disable = {
                    'latex',
                },
            },
            incremental_selection = { enable = true },
            indent = { enable = false },
            -- textobjects = { enable = true },
        })
        ---@diagnostic disable-next-line: inject-field
        -- parser_config.lilypond = { --  {{{1
        --     install_info = {
        --         url = 'https://github.com/tristanperalta/tree-sitter-lilypond',
        --         files = { 'src/parser.c' },
        --         -- optional entries:
        --         -- branch = 'main', -- default branch in case of git repo if different from master
        --         -- generate_requires_npm = false, -- if stand-alone parser without npm dependencies
        --         -- requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        --     },
        --     -- filetype = 'lilypond', -- if filetype does not match the parser name
        -- }
        --  }}}1
    end,
}

-- vim: fdm=marker
