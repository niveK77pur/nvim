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

    use(require('myplugins.editing.comment'))
    use(require('myplugins.editing.auto-pairs'))
    use(require('myplugins.editing.surround'))
    use(require('myplugins.editing.vim-easy-align'))
    use(require('myplugins.editing.vim-exchange'))
    use(require('myplugins.editing.vim-move'))
    use(require('myplugins.editing.ssr'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                   Music
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                             Language Support
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.language-support.treesitter'))
    use(require('myplugins.language-support.treesitter'))
    use(require('myplugins.language-support.BetterLua'))

    use(require('myplugins.language-support.nvim-lilypond-suite'))
    use(require('myplugins.language-support.vimtex'))

    use(require('myplugins.language-support.vim-diagram'))
    use(require('myplugins.language-support.vim-jukit'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                               Collaboration
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.collaboration.instant'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                              Language Server
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.language-server.coc'))
    use(require('myplugins.language-server.lsp-zero'))
    use(require('myplugins.language-server.nvim-cmp'))

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
