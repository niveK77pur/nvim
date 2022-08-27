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
