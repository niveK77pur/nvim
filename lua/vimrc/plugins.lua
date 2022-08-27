-- install packer if not found {{{1
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
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

    -- Interface --
    use 'sainnhe/everforest'
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
