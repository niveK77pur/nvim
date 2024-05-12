return {
    'VonHeikemen/lsp-zero.nvim',
    dependencies = {
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'folke/neodev.nvim', -- neodev needs to be setup before lspconfig
    },
    enabled = true,
    config = function()
        local lsp_zero = require('lsp-zero')
        local lspconfig = require('lspconfig')

        -- Preliminary -----------------------------------------------------
        -- lsp.preset('recommended')
        lsp_zero.set_preferences({ -- {{{
            suggest_lsp_servers = true,
            setup_servers_on_start = true,
            set_lsp_keymaps = false,
            configure_diagnostics = true,
            cmp_capabilities = true,
            manage_nvim_cmp = false, -- separate custom configuration
            call_servers = 'local',
            sign_icons = {
                error = '✘', -- '✘',
                warn = '▲', -- '▲',
                hint = '⚑', -- '∴',
                info = '', -- ''
            },
        }) -- }}}

        -- Mappings --------------------------------------------------------

        lsp_zero.on_attach(function(client, bufnr) --  {{{
            local nmap = function(LH, RH, opts, desc)
                opts['desc'] = desc
                vim.keymap.set('n', LH, RH, opts)
            end
            -- Enable completion triggered by <c-x><c-o> {{{
            do
                -- interferes with vimtex
                if not (require('vimrc.functions').plugin_loaded('vimtex')) then
                    vim.api.nvim_buf_set_option(
                        bufnr,
                        'omnifunc',
                        'v:lua.vim.lsp.omnifunc'
                    )
                end
            end --  }}}
            -- LSP Mappings. {{{
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            -- local extopts = function (opt1, opt2) return vim.fn.tbl_deep_extend('force', opt1, opt2) end

            nmap(
                '<Leader>lgD',
                vim.lsp.buf.declaration,
                bufopts,
                'Go to declaration'
            )
            nmap(
                '<Leader>lgd',
                vim.lsp.buf.definition,
                bufopts,
                'Go to definition'
            )
            nmap(
                '<Leader>lk',
                vim.lsp.buf.hover,
                bufopts,
                'Display hover information'
            )
            nmap(
                '<Leader>lgi',
                vim.lsp.buf.implementation,
                bufopts,
                'List all implementations'
            )
            nmap(
                '<C-k>',
                vim.lsp.buf.signature_help,
                bufopts,
                'Display signature information'
            )
            -- nmap('<Leader>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
            -- nmap('<Leader>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
            -- nmap('<Leader>lwl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
            nmap(
                '<Leader>lD',
                vim.lsp.buf.type_definition,
                bufopts,
                'Jump to definition of the type'
            )
            nmap(
                '<Leader>lrn',
                vim.lsp.buf.rename,
                bufopts,
                'Rename all references of symbol'
            )
            nmap(
                '<Leader>lca',
                vim.lsp.buf.code_action,
                bufopts,
                'Select available code action'
            )
            nmap(
                '<Leader>lre',
                vim.lsp.buf.references,
                bufopts,
                'List all references to symbol'
            )
            -- nmap('<Leader>lf', function() vim.lsp.buf.format { async = false } end, bufopts, 'Format buffer using LSP')
            --  }}}
        end) --  }}}

        -- LSPs ------------------------------------------------------------

        require('mason').setup({})
        require('mason-lspconfig').setup({
            handlers = {
                lsp_zero.default_setup,
            },
        })

        lspconfig.lua_ls.setup({ -- {{{
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }) -- }}}

        local pylsp_settings = { -- {{{
            pylsp = {
                plugins = {
                    pycodestyle = {
                        ignore = {
                            'E501', -- line too long
                            -- 'E302', -- expected 2 blank lines
                            -- 'E305', -- expected 2 blank lines after
                            'E221', -- multiple spaces before operator
                            'E241', -- multiple spaces after ':'
                            'E201', -- whitespace before open bracket [{(
                            'E202', -- whitespace before close bracket )}]
                            'W503', -- line break before binary operator (conflicts with 'W504')
                        },
                    },
                },
            },
        }
        if
            require('mason-registry').is_installed('pyright')
            or vim.fn.executable('pyright')
        then
            -- additional tweaks to interfere less with 'pyright'
            pylsp_settings = vim.tbl_deep_extend('force', pylsp_settings, {
                pylsp = { plugins = { pyflakes = { enabled = false } } },
            })
            lspconfig.pyright.setup({})
        end
        lspconfig.pylsp.setup({
            settings = pylsp_settings,
        }) -- }}}

        lspconfig.ltex.setup({ --  {{{
            filetypes = { -- expanded from default (see :h 'lspconfig-all')
                'text',
                'markdown',
                'asciidoc',
                'bib',
                'plaintex',
                'tex',
                'gitcommit',
                'org',
                'rst',
                'rnoweb',
            },
            settings = {
                ltex = {
                    language = 'en-GB',
                },
            },
        }) --  }}}

        lspconfig.texlab.setup({ --  {{{
            settings = {
                texlab = {
                    -- formatterLineLength = vim.o.textwidth,
                    bibtexFormatter = 'latexindent',
                    latexFormatter = 'latexindent',
                    latexindent = {
                        modifyLineBreaks = true,
                    },
                },
            },
        }) --  }}}

        lspconfig.rust_analyzer.setup({ --  {{{
            settings = {
                ['rust-analyzer'] = {
                    check = {
                        command = 'clippy',
                    },
                },
            },
        }) --  }}}

        lspconfig.jdtls.setup({ --  {{{
            settings = {
                redhat = { telemetry = { enabled = false } },
            },
            -- handlers = {
            --     -- https://www.reddit.com/r/neovim/comments/1172p03/comment/j9e37o9/?utm_source=share&utm_medium=web2x&context=3
            --     ['language/status'] = function(_, result)
            --         -- disable status updates.
            --     end,
            --     ['$/progress'] = function(_, result, ctx)
            --         -- disable progress updates.
            --     end,
            -- },
        }) --  }}}

        lspconfig.nixd.setup({})
        lspconfig.nil_ls.setup({})

        -- Setup -----------------------------------------------------------
        do
            local diagnostic_config = vim.diagnostic.config()
            lsp_zero.setup()
            vim.diagnostic.config(diagnostic_config)
        end
    end,
}

-- vim: fdm=marker
