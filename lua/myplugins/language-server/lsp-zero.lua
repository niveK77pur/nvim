return { 'VonHeikemen/lsp-zero.nvim',
    dependencies = {
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
    },
    enabled = true,
    config = function()
        local lsp = require('lsp-zero')

        -- Preliminary -----------------------------------------------------
        -- lsp.preset('recommended')
        lsp.set_preferences({ -- {{{
            suggest_lsp_servers = true,
            setup_servers_on_start = true,
            set_lsp_keymaps = false,
            configure_diagnostics = true,
            cmp_capabilities = true,
            manage_nvim_cmp = false, -- separate custom configuration
            call_servers = 'local',
            sign_icons = {
                error = '✘',-- '✘',
                warn  = '▲',-- '▲',
                hint  = '⚑',-- '∴',
                info  = '',-- ''
            }
        }) -- }}}

        -- Mappings --------------------------------------------------------

        lsp.on_attach(function(client, bufnr) --  {{{
            local nmap = function(LH, RH, opts, desc)
                opts['desc'] = desc
                vim.keymap.set('n', LH, RH, opts)
            end
            -- Enable completion triggered by <c-x><c-o> {{{
            do
                -- interferes with vimtex
                if not ( require('vimrc.functions').plugin_loaded('vimtex') ) then
                    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                end
            end --  }}}

            -- Diagnostics Mappings. {{{
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            local opts = { noremap = true, silent = true }
            nmap('<Leader>ld', vim.diagnostic.open_float, opts, 'Show diagnostic in float window')
            nmap('[d', vim.diagnostic.goto_prev, opts, 'Go to previous diagnostic')
            nmap(']d', vim.diagnostic.goto_next, opts, 'Go to next diagnostic')
            nmap('<Leader>lq', vim.diagnostic.setloclist, opts, 'Add buffer diagnostics to location list')
            --  }}}
            -- LSP Mappings. {{{
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            -- local extopts = function (opt1, opt2) return vim.fn.tbl_deep_extend('force', opt1, opt2) end

            nmap('<Leader>lgD', vim.lsp.buf.declaration, bufopts, 'Go to declaration')
            nmap('<Leader>lgd', vim.lsp.buf.definition, bufopts, 'Go to definition')
            nmap('<Leader>lk', vim.lsp.buf.hover, bufopts, 'Display hover information')
            nmap('<Leader>lgi', vim.lsp.buf.implementation, bufopts, 'List all implementations')
            nmap('<C-k>', vim.lsp.buf.signature_help, bufopts, 'Display signature information')
            -- nmap('<Leader>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
            -- nmap('<Leader>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
            -- nmap('<Leader>lwl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
            nmap('<Leader>lD', vim.lsp.buf.type_definition, bufopts, 'Jump to definition of the type')
            nmap('<Leader>lrn', vim.lsp.buf.rename, bufopts, 'Rename all references of symbol')
            nmap('<Leader>lca', vim.lsp.buf.code_action, bufopts, 'Select available code action')
            nmap('<Leader>lre', vim.lsp.buf.references, bufopts, 'List all references to symbol')
            nmap('<Leader>lf', function() vim.lsp.buf.format { async = false } end, bufopts, 'Format buffer using LSP')
            --  }}}
        end) --  }}}

        -- LSPs ------------------------------------------------------------

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                'lua_ls',
            },
            handlers = {
                lsp.default_setup,
            }
        })

        lsp.configure('lua_ls', { -- {{{
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    telemetry = {
                        enable = false,
                    },
                }
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
        if require('mason-registry').is_installed('pyright') then
            -- additional tweaks to interfere less with 'pyright'
            pylsp_settings = vim.tbl_deep_extend('force', pylsp_settings, {
                pylsp = { plugins = { pyflakes = { enabled = false } } }
            })
        end
        lsp.configure('pylsp', {
            settings = pylsp_settings,
        }) -- }}}

        lsp.configure('ltex', { --  {{{
            filetypes = { -- expanded from default (see :h 'lspconfig-all')
                "text", "markdown", 'asciidoc',
                "bib", "plaintex", "tex",
                "gitcommit", "org", "rst", "rnoweb",
            },
            settings = {
                ltex = {
                    language = 'en-GB',
                },
            },
        }) --  }}}

        lsp.configure('texlab', {
            settings = {
                texlab = {
                    -- formatterLineLength = vim.o.textwidth,
                    bibtexFormatter = 'latexindent',
                    latexFormatter = 'latexindent',
                    latexindent = {
                        modifyLineBreaks = true,
                    }
                }
            }
        })

        lsp.configure('rust_analyzer', { --  {{{
            settings = {
                ['rust-analyzer'] = {
                    check = {
                        command = "clippy",
                    },
                },
            },
        }) --  }}}

        -- Setup -----------------------------------------------------------
        do
            local diagnostic_config = vim.diagnostic.config()
            lsp.setup()
            vim.diagnostic.config(diagnostic_config)
        end

    end,
}

-- vim: fdm=marker
