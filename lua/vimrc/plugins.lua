-- install packer if not found {{{
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end
--  }}}
-- automatically :PackerCompile when file is written {{{
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
--  }}}

return require('packer').startup({function(use)

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                Handy Tools
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.handy-tools.localrc'))
    use(require('myplugins.handy-tools.multi-cursor'))
    use(require('myplugins.handy-tools.printer'))

    use(require('myplugins.handy-tools.telescope'))
    use(require('myplugins.handy-tools.fzf-lua'))
    use(require('myplugins.handy-tools.fzf-vim'))

    use(require('myplugins.handy-tools.snippets'))

    use(require('myplugins.handy-tools.gitsigns'))
    use(require('myplugins.handy-tools.treesitter-context'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                  Writing
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.writing.pencil'))
    use(require('myplugins.writing.ditto'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                 Interface
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.interface.colorscheme'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                  Editing
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use { 'scrooloose/nerdcommenter', disable=true }
    use { 'numToStr/Comment.nvim', disable=false, -- {{{
        config = function()
            require('Comment').setup{
                -- Enable keybindings
                -- NOTE: If given `false` then the plugin won't create any mappings
                mappings = {
                    -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
                    basic = true,
                    -- Extra mapping; `gco`, `gcO`, `gcA`
                    extra = true,
                    -- Extended mapping; `g>` `g<` `g>[count]{motion}` `g<[count]{motion}`
                    extended = false,
                },
                -- Changing mappings to use <Leader>c (like NERDCommenter)
                -- makes operator-pending mappings not work
            }
        end,
    } -- }}}

    use { 'jiangmiao/auto-pairs', disable=false, -- {{{
        config = function()
            local augroup = vim.api.nvim_create_augroup('AutoPairsVim', { clear=false })
            vim.api.nvim_create_autocmd('FileType', {
                group = augroup,
                pattern = { 'lilypond' },
                callback = function()
                    vim.b.AutoPairs = {
                        ['{'] ='}',
                        ['"'] = '"',
                        ['`'] = '`',
                    }
                end,
                desc = 'Set which LilyPond characters should be auto-paired.',
            })
            vim.api.nvim_create_autocmd('FileType', {
                group = augroup,
                pattern = { 'vim' },
                callback = function()
                    vim.b.AutoPairs = {
                        ['('] = ')',
                        ['['] = ']',
                        ['{'] = '}',
                        ["'"] = "'",
                        ['`'] = '`',
                    }
                end,
                desc = 'Set which VIM characters should be auto-paired.',
            })
            -- Default: <M-p>
            vim.g.AutoPairsShortcutToggle = "<Leader><M-p>"
            -- Default: <M-b>
            -- vim.g.AutoPairsBackInsert = "<Leader><M-b>"
        end,
    } -- }}}

    use { 'tpope/vim-surround', disable=true, -- {{{
        config = function()
            local map = vim.keymap.set

            vim.g.surround_no_mappings = true
            map('n', 'ds', '<Plug>Dsurround')
            map('n', 'cs', '<Plug>Csurround')
        end
    } -- }}}
    use { 'kylechui/nvim-surround', disable=false, -- {{{
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    visual = '<Leader>s',
                },
                aliases = {
                    ["a"] = false,
                    ["b"] = false,
                    ["B"] = false,
                    ["r"] = false,
                    ["s"] = false,
                },
                -- move_cursor = false,
            })

            local augroup_nvimsurround = vim.api.nvim_create_augroup('nvimsurround', {})
            vim.api.nvim_create_autocmd({ "FileType" }, {
                group = augroup_nvimsurround,
                pattern = { 'lua' },
                desc = "nvim-surround config for lua filetype",
                callback = function()
                    require('nvim-surround').buffer_setup {
                        surrounds = {
                            ['s'] = {
                                add = { '[[', ']]' },
                                find = "%[(=*)%[.-%]%1%]",
                                -- find = function()
                                --     local config = require("nvim-surround.config")
                                --     -- return config.get_selection({ motion = '2a[' })
                                --     return config.get_selection({ node = 'string' })
                                -- end,
                                delete = "^(%[=*%[)().-(%]=*%])()$",
                                -- delete = '^(%[%[)().*(%]%])()$',
                                change = { target =  "^(%[=*%[)().-(%]=*%])()$"},
                            },
                        }
                    }
                end,
            })
        end
    } -- }}}

    use { 'junegunn/vim-easy-align', disable=false,-- {{{
        config = function()
            local map = function(mode, LH, RH, args) vim.keymap.set(mode, LH, RH, args) end

            -- https://github.com/junegunn/vim-easy-align#1-plug-mappings-interactive-mode
            map({'n','x'}, '<Leader>a', '<Plug>(EasyAlign)')

            -- https://github.com/junegunn/vim-easy-align#disabling-foldmethod-during-alignment
            vim.g.easy_align_bypass_fold = 1
        end,
    } -- }}}

    use { 'tommcdo/vim-exchange', disable=false }

    use { 'matze/vim-move', disable=true,-- {{{
        config = function()
            -- vim.g.move_key_modifier = 'S-A'
            -- vim.g.move_key_modifier_visualmode = 'S-A'
        end,
    } -- }}}

    use { "cshuaimin/ssr.nvim", disable=true, -- {{{
        module = "ssr",
        setup = function()
            -- ts : Treesitter Search-and-replace
            vim.keymap.set({ "n", "x" }, "<Leader>ts", function() require("ssr").open() end)
        end,
        -- Calling setup is optional.
        config = function()
            require("ssr").setup {
                min_width = 50,
                min_height = 5,
                keymaps = {
                    close = "q",
                    next_match = "n",
                    prev_match = "N",
                    replace_all = "<leader><cr>",
                },
            }
        end
    } -- }}}

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                   Music
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                             Language Support
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use { 'nvim-treesitter/nvim-treesitter', disable=false, -- {{{
        run = function()
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
    } -- }}}
    use { 'nvim-treesitter/playground', disable=false, -- {{{
        cmd = { 'TSPlaygroundToggle' },
        run = ':TSInstall query',
    } -- }}}

    use { 'euclidianAce/BetterLua.vim', disable=false,-- {{{
        ft = 'lua',
    } -- }}}

    use { 'martineausimon/nvim-lilypond-suite', disable=false,-- {{{
        requires = {
            'MunifTanjim/nui.nvim',
            'uga-rosa/cmp-dictionary',
        },
        ft = { 'lilypond' },
        config = function()
            require('nvls').setup{
                lilypond = {
                    mappings = {
                        player = "<F3>",
                        compile = "<F5>",
                        open_pdf = "<F6>",
                        switch_buffers = "<F2>",
                        insert_version = "<F4>"
                    },
                    options = {
                        pitches_language = "default",
                        output = "pdf",
                        -- main_file = "main.ly"
                    },
                },
            }

            vim.api.nvim_create_autocmd( 'QuickFixCmdPost', {
                command = "cwindow",
                pattern = "*"
            })

            local LILYDICTPATH = packer_plugins['nvim-lilypond-suite'].path .. '/lilywords'
            require('cmp_dictionary').setup{
                dic = {
                    ["lilypond"] = {
                        LILYDICTPATH .. '/accidentalsStyles',
                        LILYDICTPATH .. '/articulations',
                        LILYDICTPATH .. '/clefs',
                        LILYDICTPATH .. '/contextProperties',
                        LILYDICTPATH .. '/contexts',
                        LILYDICTPATH .. '/contextsCmd',
                        LILYDICTPATH .. '/dynamics',
                        LILYDICTPATH .. '/grobProperties',
                        LILYDICTPATH .. '/grobs',
                        LILYDICTPATH .. '/headerVariables',
                        LILYDICTPATH .. '/keywords',
                        LILYDICTPATH .. '/languageNames',
                        LILYDICTPATH .. '/markupCommands',
                        LILYDICTPATH .. '/musicCommands',
                        LILYDICTPATH .. '/musicFunctions',
                        LILYDICTPATH .. '/paperVariables',
                        LILYDICTPATH .. '/repeatTypes',
                        LILYDICTPATH .. '/scales',
                        LILYDICTPATH .. '/translators',
                    }
                }
            }
        end
    } -- }}}

    use { 'lervag/vimtex', disable=false,-- {{{
        ft = { 'latex', 'tex', 'plaintex', 'context', 'bib' },
        config = function()
            local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
            -- Settings --
            vim.g.vimtex_view_method = 'zathura'
            vim.g.vimtex_fold_enabled = 1
            vim.g.tex_conceal = 'adbmgs'

            -- Mappings --
            nmap('<LocalLeader>ls', '<plug>(vimtex-compile-ss)')
            nmap('<LocalLeader>cw', ':VimtexCountWords<CR>')
            nmap('<LocalLeader>cl', ':VimtexCountLetters<CR>')

            -- Latex Documentation --
            -- vim.cmd [[
            --     let g:vimtex_doc_handlers = ['TexdocHandler']
            --     function! TexdocHandler(context)
            --     call vimtex#doc#make_selection(a:context)
            --     if !empty(a:context.selected)
            --         silent execute '!texdoc' a:context.selected '&'
            --     endif
            --     return 1
            --     endfunction
            -- ]]

            -- Warnings to ignore --
            vim.g.vimtex_quickfix_ignore_filters = {
                'Underfull',
                'Overfull',
                -- 'Font Warning:',
                'Empty bibliography',
                -- 'LaTeX hooks Warning: Generic hook',
                'Package hyperref Warning: Draft mode on.',
                -- 'siunitx/group-digits',
                -- ['overfull'] = 0,
                -- ['underfull'] = 0,
                -- ['packages'] = {
                --    ['hyperref'] = 0,
                -- },
            }
        end,
    } -- }}}

    use { 'zhaozg/vim-diagram', disable=true, -- {{{
        cond = function()
            local ext = vim.fn.expand('%:e')
            return ext == 'mmd' or ext == 'seq' or ext == 'sequence'
        end,
        setup = function()
            local augroup_mermaid = vim.api.nvim_create_augroup('mermaid', {})
            vim.api.nvim_create_autocmd({ "BufEnter" }, {
                group = augroup_mermaid,
                pattern = { '*.mmd' },
                desc = "Also recognize mmd extension for mermaid",
                callback = function()
                    vim.bo.filetype = 'sequence'
                end,
            })
        end,
    } -- }}}

    use { 'luk400/vim-jukit', disable=false, -- {{{
        event = 'BufRead *.ipynb',
        setup = function()
            -- disable default mappings
            vim.g.jukit_mappings = 0
        end,
        config = function()
            vim.cmd[[
                " Splits
                nnoremap <LocalLeader>os :call jukit#splits#output()<cr>
                nnoremap <LocalLeader>od :call jukit#splits#close_output_split()<cr>
                nnoremap <LocalLeader>So :call jukit#splits#show_last_cell_output(1)<cr>
                nnoremap <LocalLeader>Sl :call jukit#layouts#set_layout()<cr>
                " Sending code
                nnoremap <LocalLeader><space> :call jukit#send#section(0)<cr>
                nnoremap <LocalLeader>cc :call jukit#send#until_current_section()<cr>
                nnoremap <LocalLeader>ca :call jukit#send#all()<cr>
                nnoremap <LocalLeader><cr> :call jukit#send#line()<cr>
                vnoremap <LocalLeader><cr> :<C-U>call jukit#send#selection()<cr>
                " Cells
                nnoremap <LocalLeader>j :call jukit#cells#jump_to_next_cell()<cr>
                nnoremap <LocalLeader>k :call jukit#cells#jump_to_previous_cell()<cr>
                nnoremap <LocalLeader>co :call jukit#cells#create_below(0)<cr>
                nnoremap <LocalLeader>cO :call jukit#cells#create_above(0)<cr>
                nnoremap <LocalLeader>ct :call jukit#cells#create_below(1)<cr>
                nnoremap <LocalLeader>cT :call jukit#cells#create_above(1)<cr>
                nnoremap <LocalLeader>cd :call jukit#cells#delete()<cr>
                nnoremap <LocalLeader>cs :call jukit#cells#split()<cr>
                nnoremap <LocalLeader>cM :call jukit#cells#merge_above()<cr>
                nnoremap <LocalLeader>cm :call jukit#cells#merge_below()<cr>
                nnoremap <LocalLeader>ck :call jukit#cells#move_up()<cr>
                nnoremap <LocalLeader>cj :call jukit#cells#move_down()<cr>
                " ipynb conversion
                nnoremap <LocalLeader>np :call jukit#convert#notebook_convert("jupyter-notebook")<cr>
            ]]
        end,

    } -- }}}

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                               Collaboration
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use { 'jbyuki/instant.nvim', disable = true,-- {{{
        -- set cmd = ???
        config = function()
            vim.g.instant_username = 'MaceVimdu'
        end,
    } -- }}}

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                              Language Server
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use { 'neoclide/coc.nvim', branch = 'release', disable=true,-- {{{
        run = ':CocUpdate',
        config = function()
            local map = function(mode, LH, RH, args) vim.keymap.set(mode, LH, RH, args) end

            vim.g.coc_global_extensions = {
                'coc-json',
                -- 'coc-lua',
                'coc-sumneko-lua',
                'coc-jedi',
                'coc-clangd',
                'coc-sh',
                'coc-vimlsp',
                'coc-vimtex',
                'coc-ultisnips',
                'coc-syntax',
                'coc-emoji',
                'coc-dictionary',
            }

            -- Use <c-space> to trigger completion.
            map('i', '<c-space>', 'coc#refresh()', { silent=true, expr=true })

            -- Remap <C-f> and <C-b> for scroll float windows/popups.
            map({'n','v'}, '<C-f>', [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]], {  silent=true, nowait=true, expr=true })
            map({'n','v'}, '<C-b>', [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]], {  silent=true, nowait=true, expr=true })
            map('i', '<C-f>', [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"]], {  silent=true, nowait=true, expr=true })
            map('i', '<C-b>', [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"]], {  silent=true, nowait=true, expr=true })

            -- Symbol renaming.
            map('n', '<leader>Cr', '<Plug>(coc-rename)', { silent=true })

            -- Use `[g` and `]g` to navigate diagnostics
            -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
            map('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent=true })
            map('n', ']g', '<Plug>(coc-diagnostic-next)', { silent=true })

            -- GoTo code navigation.
            map('n', '<Leader>Cgd', '<Plug>(coc-definition)', { silent=true })
            map('n', '<Leader>Cgy', '<Plug>(coc-type-definition)', { silent=true })
            map('n', '<Leader>Cgi', '<Plug>(coc-implementation)', { silent=true })
            map('n', '<Leader>Cgr', '<Plug>(coc-references)', { silent=true })

            -- Formatting selected code.
            map({'x','n'}, '<Leader>Cf', '<Plug>(coc-format-selected)')

            -- vim.api.nvim_set_hl
            vim.cmd [[
                highlight link CocErrorVirtualText Exception
                highlight link CocWarningVirtualText Type
                " highlight link CocInfoVirtualText Special
                highlight link CocHintVirtualText Macro
            ]]

        end,
    } -- }}}

    use { 'VonHeikemen/lsp-zero.nvim', disable = false, -- {{{
        requires = {
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
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
                    local vimtex_loaded = packer_plugins['vimtex'] and packer_plugins['vimtex'].loaded
                    if not ( vimtex_loaded ) then
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

            lsp.ensure_installed({
                'sumneko_lua',
                'pyright',
                'pylsp',
                'bashls'
            })

            lsp.configure('sumneko_lua', { -- {{{
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
                    "text", "markdown",
                    "bib", "plaintex", "tex",
                    "gitcommit", "org", "rst", "rnoweb",
                },
            }) --  }}}

            -- Setup -----------------------------------------------------------
            do
                local diagnostic_config = vim.diagnostic.config()
                lsp.setup()
                vim.diagnostic.config(diagnostic_config)
            end

        end,
    } -- }}}

    use { 'hrsh7th/nvim-cmp', disable = false, -- {{{
        requires = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-emoji',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-omni',
            'hrsh7th/cmp-path',
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
    } -- }}}

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                   Candy
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use { 'raghur/vim-ghost', disable=true,-- {{{
        run = ':GhostInstall',
        cmd = { 'GhostInstall', 'GhostStart' },
        config = function()
            vim.cmd [[
                function! s:SetupGhostBuffer()
                    " mappings
                    nmap <buffer> ZZ :%bdelete!<CR>

                    " settings
                    CocDisable
                    set autowriteall

                    " site specific settings
                    let l:fname = expand("%:a")
                    if l:fname =~# '\v/ghost-(github|reddit)\.com-'
                        set ft=markdown
                    elseif l:fname =~# '/ghost-localhost.*jupyter-'
                        set ft=python
                        set tw=0
                    elseif l:fname =~# '/ghost-www.overleaf'
                        set ft=tex
                        set tw=0
                        set ts=4 sw=0
                    endif
                endfunction

                augroup vim-ghost
                    au!
                    au User vim-ghost#connected call s:SetupGhostBuffer()
                augroup END
            ]]
        end,
    } -- }}}
    use { 'subnut/nvim-ghost.nvim', disable=false, -- {{{
        run = ':call nvim_ghost#installer#install()',
        config = function()
            vim.g.nvim_ghost_super_quiet = 1

            -- All autocommands should be in 'nvim_ghost_user_autocommands' group
            local augroup_nvim_ghost_user_autocommands = vim.api.nvim_create_augroup('nvim_ghost_user_autocommands', {})
            local function addWebsiteSettings(opts) --  {{{
                vim.api.nvim_create_autocmd({ 'User' }, {
                    group = augroup_nvim_ghost_user_autocommands,
                    pattern = opts.pattern,
                    desc = opts.desc,
                    callback = opts.callback,
                })
            end --  }}}

            addWebsiteSettings {
                pattern = { 'www.overleaf.com' },
                desc = "nvim-ghost: set Overleaf settings",
                callback = function() --  {{{
                    vim.opt.filetype = 'tex'
                    vim.opt.foldenable = false
                    vim.opt.wrap = true

                    -- avoid being overwriten by ftplugin
                    vim.schedule(function()
                        vim.opt.textwidth = 0
                        vim.opt.tabstop = 4
                        vim.opt.shiftwidth = 0
                    end)

                    -- taken from markdown ftplugin
                    for _,key in pairs{ 'j', 'k', '0', '$' } do
                        vim.keymap.set('n', key, 'g'..key, { desc = string.format('remap %s for better text editing', key) })
                    end
                end --  }}}
            }

            addWebsiteSettings {
                pattern = { 'github.com' },
                desc = "nvim-ghost: set GitHub settings",
                callback = function()
                    vim.opt.filetype = 'markdown'
                end
            }

        end,
    } -- }}}

    use { 'voldikss/vim-floaterm', disable=false,-- {{{
        -- cmd = { 'FloatermNew' },
        config = function()
            local map = vim.keymap.set

            map('n', '<Leader><m-l>', ':FloatermNew --width=0.8 --height=0.8 --title=lazygit lazygit<CR>', {
                desc = 'FloatTerm with LazyGit',
            })

        end
    } -- }}}

    use { 'MunifTanjim/nui.nvim', disable=false }

    use { 'anuvyklack/pretty-fold.nvim', disable=false, -- {{{
        config = function()

            local global_setup = {
                sections = {
                    left = { 'content', },
                    right = {
                        ' ',
                        function() return ("[%dL]"):format(vim.v.foldend - vim.v.foldstart) end,
                        '[', 'percentage', ']',
                    }
                },
                matchup_patterns = {
                    {  '{', '}' },
                    { '%(', ')' }, -- % to escape lua pattern char
                    { '%[', ']' }, -- % to escape lua pattern char
                },
                -- add_close_pattern = true,
                process_comment_signs = ({'delete', 'spaces', false})[2]
            }

            local function ft_setup(lang, options) -- {{{
                local opts = vim.tbl_deep_extend('force', global_setup, options)
                -- combine global and ft specific matchup_patterns
                if opts and opts.matchup_patterns and global_setup.matchup_patterns then
                    opts.matchup_patterns = vim.list_extend(opts.matchup_patterns, global_setup.matchup_patterns)
                end
                require('pretty-fold').ft_setup(lang, opts)
            end -- }}}

            require('pretty-fold').setup(global_setup)

            ft_setup('lua', { -- {{{
                matchup_patterns = {
                    { '^%s*do$', 'end' }, -- do ... end blocks
                    { '^%s*if', 'end' },  -- if ... end
                    { '^%s*for', 'end' }, -- for
                    { 'function[^%(]*%(', 'end' }, -- 'function( or 'function (''
                },
            }) -- }}}

            ft_setup('vim', { -- {{{
                matchup_patterns = {
                    { '^%s*function!?[^%(]*%(', 'endfunction' },
                },
            }) -- }}}

        end,
    } -- }}}
    use { 'anuvyklack/fold-preview.nvim', disable=false, -- {{{
        requires = 'anuvyklack/keymap-amend.nvim',
        config = function()
            require('fold-preview').setup()
        end
    } -- }}}

    use { 'ggandor/leap.nvim', disable=false, -- {{{
        config = function()
            local l = require('leap')
            -- vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = '#707070' })
            -- l.set_default_keymaps(true)
            l.add_default_mappings()

            -- target_windows = { vim.fn.win_getid() }
            -- require('leap').leap { target_windows = { vim.fn.win_getid() } }
            -- require('leap').leap { target_windows = vim.tbl_filter(
            --   function (win) return vim.api.nvim_win_get_config(win).focusable end,
            --   vim.api.nvim_tabpage_list_wins(0)
            -- )}
        end
    } -- }}}
    use { 'jinh0/eyeliner.nvim', disable=true, -- {{{
        config = function()
            require'eyeliner'.setup {
                highlight_on_key = true
            }
        end
    } -- }}}
    use { 'rlane/pounce.nvim', disable=true, -- {{{
        config = function ()
            require'pounce'.setup{
                accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
                accept_best_key = "<enter>",
                multi_window = true,
                debug = false,
            }

            vim.cmd [[
                nmap a <cmd>Pounce<CR>
                nmap A <cmd>PounceRepeat<CR>
                vmap a <cmd>Pounce<CR>
                omap ga <cmd>Pounce<CR>  " 's' is used by vim-surround
            ]]

            -- change colors with :highlight (check ':h pounce.txt')

        end
    } -- }}}

    use { 'NvChad/nvim-colorizer.lua', disable=false, -- {{{
        config = function()
            require'colorizer'.setup{
                mode = ({'foreground','background', 'virtualtext'})[3],
            }
        end
    } -- }}}
    use { "max397574/colortils.nvim", disable=true, -- {{{
        cmd = "Colortils",
        config = function()
            require("colortils").setup()
        end,
    } -- }}}

    use { "anuvyklack/windows.nvim", disable=false, -- {{{
        requires = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim"
        },
        cmd = { 'WindowsEnableAutowidth', 'WindowsToggleAutowidth', 'WindowsMaximaze', },
        config = function()
            local width = 10
            vim.o.winwidth = width
            vim.o.winminwidth = width
            vim.o.equalalways = false

            require('windows').setup{
                animation = {
                    enable = true,
                    duration = 150,
                    -- fps = 30,
                }
            }

            local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
            nmap('<Leader>we', '<cmd>WindowsEnableAutowidth<CR>')
            nmap('<Leader>wd', '<cmd>WindowsDisableAutowidth<CR>')
            nmap('<Leader>wt', '<cmd>WindowsToggleAutowidth<CR>')
            nmap('<Leader>wm', '<cmd>WindowsMaximaze<CR>')
        end
    } -- }}}

    use { "narutoxy/silicon.lua", disable=false, -- {{{
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require('silicon').setup({})
            -- local silicon = require('silicon')
            -- Generate image of lines in a visual selection
            vim.keymap.set('v', '<Leader>S',  function() silicon.visualise_api({ to_clip=true }) end )
            -- Generate image of a whole buffer, with lines in a visual selection highlighted
            -- vim.keymap.set('v', '<Leader>bs', function() silicon.visualise_api({to_clip = true, show_buf = true}) end )
            -- Generate visible portion of a buffer
            -- vim.keymap.set('n', '<Leader>s',  function() silicon.visualise_api({to_clip = true, visible = true}) end )
            -- Generate current buffer line in normal mode
            -- vim.keymap.set('n', '<Leader>s',  function() silicon.visualise_api({to_clip = true}) end )
        end
    } -- }}}

    -- Automatically set up your configuration after cloning packer.nvim {{{
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
    -- }}}

end,
config = { -- {{{
    display = {
        -- open_fn = require('packer.util').float,
    },
    profile = {
        enable = true,
    },
    git = {
        clone_timeout = 60, -- Timeout, in seconds, for git clones
    },
}}) -- }}}
-- vim: fdm=marker
