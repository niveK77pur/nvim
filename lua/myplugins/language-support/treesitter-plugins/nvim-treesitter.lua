return { 'nvim-treesitter/nvim-treesitter', disable=false,
    build = function()
        require('nvim-treesitter.install').update({ with_sync = true })
        vim.cmd[[TSUpdateSync]]
    end,
    config = function()
        require'nvim-treesitter.configs'.setup {

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
                disable = { "latex", },
            },
            incremental_selection = { enable = true },
            indent = { enable = false },
            -- textobjects = { enable = true },

        }

        -- WORKAROUND
        -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
        --[[
        vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
        group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
        callback = function()
            vim.opt.foldmethod     = 'expr'
            vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
        end
        })
        --]]
        -- ENDWORKAROUND

    end,
}
