-- install packer if not found {{{1
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end
-- automatically :PackerCompile when file is written  {{{1
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
-- }}}1

return require('packer').startup({function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Handy tools --

    use { disable=true, 'thinca/vim-localrc' }
    use { 'MunifTanjim/exrc.nvim', -- local .nvimrc files
        requires = { 'MunifTanjim/nui.nvim', opt=true },
        config = function() -- {{{
            -- disable built-in local config file support
            vim.o.exrc = false
            require("exrc").setup({
                files = {
                    ".nvimrc.lua",
                    ".nvimrc",
                    ".exrc.lua",
                    ".exrc",
                },
            })
        end, -- }}}
    }

    use { 'mg979/vim-visual-multi', branch = 'master',
        config = function() -- {{{
            vim.g.VM_leader = [[\]]
            vim.g.VM_theme = 'iceblue'
            vim.g.VM_mouse_mappings = 1
            -- mouse mappings not working? :(
            vim.keymap.set('n', '<C-LeftMouse>', '<Plug>(VM-Mouse-Cursor)')
            vim.keymap.set('n', '<C-RightMouse>', '<Plug>(VM-Mouse-Word)')
            vim.keymap.set('n', '<M-C-RightMouse>', '<Plug>(VM-Mouse-Column)')
            vim.g.VM_maps = {
                -- https://github.com/mg979/vim-visual-multi/wiki/Quick-start#undoredo
                ["Undo"] = 'u',
                ["Redo"] = '<C-r>',
            }
        end, -- }}}
    }

    use { disable = true,
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function() -- {{{
            local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
            local tb = require('telescope.builtin')
            nmap('<leader>ff', function() tb.find_files() end)
            nmap('<leader>fr', function() tb.live_grep() end)
            nmap('<leader>fb', function() tb.buffers() end)
            nmap('<leader>fh', function() tb.help_tags() end)
            nmap('<leader>tj', function() tb.jumplist() end)
            nmap('<leader>tm', function() tb.marks() end)
            nmap('<leader>tc', function() tb.command_history() end)
            nmap('<leader>ts', function() tb.search_history() end)
            nmap('<leader>tt', function() tb.treesitter() end)
        end, -- }}}
    }

    use {
        { 'junegunn/fzf', run = './install --xdg --all' },
        {
            'junegunn/fzf.vim',
            config = function() -- {{{
                local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
                local imap = function(LH, RH, args) vim.keymap.set('i', LH, RH, args) end

                -- FZF Commands
                nmap('<Leader>fr', ':Rg<CR>')
                nmap('<Leader>ff', ':Files<CR>')
                nmap('<Leader>fg', ':GFiles<CR>')
                nmap('<Leader>fb', ':Buffers<CR>')
                nmap('<Leader>fl', ':BLines<CR>')
                nmap('<Leader>fL', ':Lines<CR>')
                nmap('<Leader>fh', ':Helptags<CR>')
                nmap('<Leader>fm', ':Marks<CR>')
                nmap('<Leader>f:', ':History:<CR>')
                nmap('<Leader>f/', ':History/:<CR>')
                nmap('<Leader>fs', ':Snippets:<CR>')

                -- Insert mode completion
                imap('<Leader><c-x><c-k>', '<plug>(fzf-complete-word)')
                imap('<Leader><c-x><c-f>', '<plug>(fzf-complete-path)')
                imap('<Leader><c-x><c-j>', '<plug>(fzf-complete-file-ag)')
                imap('<Leader><c-x><c-l>', '<plug>(fzf-complete-line)')
                imap('<Leader><c-x><c-L>', '<plug>(fzf-complete-buffer-line)')
            end, -- }}}
        },
    }

    use {
        'SirVer/ultisnips',
        config = function() -- {{{
            vim.g.UltiSnipsEditSplit = 'tabdo'
            vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath('config') .. '/UltiSnips' }
        end, --}}}
    }

    -- Writing --

    use {
        'preservim/vim-pencil',
        ft = { 'tex', 'latex', 'text', 'clipboard' },
        config = function() -- {{{
            local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
            -- vim.g['pencil#autoformat'] = 1
            -- vim.g['pencil#wrapModeDefault'] = 'hard'   -- default is 'hard'
            -- vim.g['pencil#textwidth'] = 74
            -- vim.g['pencil#cursorwrap'] = 1     -- 0=disable, 1=enable (def)

            nmap('<Leader>pt', ':PencilToggle<CR>')
            nmap('<Leader>po', ':PencilOff<CR>')
            nmap('<Leader>ph', ':PencilHard<CR>')
            nmap('<Leader>ps', ':PencilSoft<CR>')
        end, --}}}
    }

    use {
        'dbmrq/vim-ditto',
        ft = { 'tex', 'latex', 'text', 'markdown' },
        config = function() -- {{{
            local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end

            -- Turn Ditto on and off
            nmap('<Leader>dt', '<Plug>ToggleDitto')
            -- Jump to the next word
            nmap('<Leader>dn', '<Plug>DittoNext')
            -- Jump to the previous word
            nmap('<Leader>dp', '<Plug>DittoPrev')
            -- Ignore the word under the cursor
            nmap('<Leader>d+', '<Plug>DittoGood')
            -- Stop ignoring the word under the cursor
            nmap('<Leader>d-', '<Plug>DittoBad')
            -- Show the next matches
            nmap('<Leader>d>', '<Plug>DittoMore')
            -- Show the previous matches
            nmap('<Leader>d<', '<Plug>DittoLess')

            vim.cmd [[
                augroup ditto
                    autocmd!
                    au FileType markdown,text,tex,latex DittoOn
                augroup END
            ]]
        end, --}}}
    }


    -- Interface --
    use 'sainnhe/everforest'

    -- Editing --

    use { disable=true, 'scrooloose/nerdcommenter' }
    use {
        'numToStr/Comment.nvim',
        config = function() -- {{{
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
        end, -- }}}
    }

    use {
        'jiangmiao/auto-pairs',
        config = function() -- {{{
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
        end, -- }}}
    }

    use { 'tpope/vim-surround' }

    use {
        'junegunn/vim-easy-align',
        config = function() -- {{{
            local map = function(mode, LH, RH, args) vim.keymap.set(mode, LH, RH, args) end

            -- https://github.com/junegunn/vim-easy-align#1-plug-mappings-interactive-mode
            map({'n','x'}, '<Leader>a', '<Plug>(EasyAlign)')

            -- https://github.com/junegunn/vim-easy-align#disabling-foldmethod-during-alignment
            vim.g.easy_align_bypass_fold = 1
        end, -- }}}
    }

    use { 'tommcdo/vim-exchange' }

    use { disable=true,
        'matze/vim-move',
        config = function() -- {{{
            -- vim.g.move_key_modifier = 'S-A'
            -- vim.g.move_key_modifier_visualmode = 'S-A'
        end, -- }}}
    }

    -- Music --

    -- Language support --

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
        config = function() -- {{{
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

                --[[
                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                    -- the name of the parser)
                    -- list of language that will be disabled
                    disable = { "c", "rust" },

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                --]]
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

        end, -- }}}
    }

    use {
        'euclidianAce/BetterLua.vim',
        ft = 'lua',
    }

    use {
        'martineausimon/nvim-lilypond-suite',
        requires = { 'MunifTanjim/nui.nvim' },
        ft = { 'lilypond' },
    }

    use {
        'lervag/vimtex',
        ft = { 'latex', 'tex', 'plaintex', 'context', 'bib' },
        config = function() -- {{{
            local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
            -- Settings --
            -- vim.g.vimtex_view_method = 'zathura'
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
                'Font Warning:',
                'Empty bibliography',
                'LaTeX hooks Warning: Generic hook',
                -- 'siunitx/group-digits',
                -- ['overfull'] = 0,
                -- ['underfull'] = 0,
                -- ['packages'] = {
                --    ['hyperref'] = 0,
                -- },
            }
        end, --}}}
    }

    -- Collaboration --
    use { disable = true,
        'jbyuki/instant.nvim',
        -- set cmd = ???
        config = function()
            vim.g.instant_username = 'MaceVimdu'
        end,
    }
    -- Language Server --
    use {
        'neoclide/coc.nvim', branch = 'release',
        run = ':CocUpdate',
        config = function() -- {{{
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

        end, -- }}}
    }

    -- Candy --

    use {
        'raghur/vim-ghost',
        run = ':GhostInstall',
        cmd = { 'GhostInstall', 'GhostStart' },
        config = function() -- {{{
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
        end, -- }}}
    }

    use { disable = true,
        'voldikss/vim-floaterm'
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end,
config = { -- {{{
    display = {
        open_fn = require('packer.util').float,
    },
    profile = {
        enable = true,
    },
}}) -- }}}

-- vim: fdm=marker
