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
