-- install packer if not found {{{
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
--  }}}
-- automatically :PackerCompile when file is written {{{
local augroup_packer_user_config = vim.api.nvim_create_augroup('packer_user_config', {})
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup_packer_user_config,
    pattern = { 'plugins.lua', vim.fn.stdpath('config') .. '/lua/myplugins/**/*.lua' },
    desc = "automatically :PackerCompile when file is written",
    callback = function()
        vim.cmd[[source <afile> | PackerCompile]]
    end,
})
--  }}}

return require('packer').startup({function(use)

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                Handy Tools
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.handy-tools.localrc')) -- works
    use(require('myplugins.handy-tools.multi-cursor')) -- works
    use(require('myplugins.handy-tools.printer')) -- works

    -- use(require('myplugins.handy-tools.telescope'))
    use(require('myplugins.handy-tools.fzf-lua')) -- works
    -- use(require('myplugins.handy-tools.fzf-vim'))

    use(require('myplugins.handy-tools.snippets')) -- works

    use(require('myplugins.handy-tools.gitsigns')) -- works
    use(require('myplugins.handy-tools.treesitter-context')) -- works

    use(require('myplugins.handy-tools.trailblazer'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                  Writing
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.writing.pencil')) -- works
    use(require('myplugins.writing.ditto')) -- works

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                 Interface
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.interface.colorscheme')) -- works

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                  Editing
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.editing.comment')) -- works
    use(require('myplugins.editing.auto-pairs')) -- works
    use(require('myplugins.editing.surround')) -- works
    use(require('myplugins.editing.vim-easy-align')) -- works
    use(require('myplugins.editing.vim-exchange')) -- works
    -- use(require('myplugins.editing.vim-move'))
    -- use(require('myplugins.editing.ssr'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                   Music
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                             Language Support
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.language-support.treesitter')) -- works
    use(require('myplugins.language-support.BetterLua')) -- works

    use(require('myplugins.language-support.nvim-lilypond-suite')) -- works
    use(require('myplugins.language-support.vimtex')) -- works

    -- use(require('myplugins.language-support.vim-diagram'))
    use(require('myplugins.language-support.vim-jukit')) -- works

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                               Collaboration
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- use(require('myplugins.collaboration.instant'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                              Language Server
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- use(require('myplugins.language-server.coc'))
    use(require('myplugins.language-server.lsp-zero')) -- works
    use(require('myplugins.language-server.nvim-cmp')) -- works

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                   Candy
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.candy.ghost')) -- works

    use(require('myplugins.candy.vim-floaterm')) -- works
    use(require('myplugins.candy.nui')) -- works

    use(require('myplugins.candy.fold')) -- works
    use(require('myplugins.candy.leap')) -- works

    use(require('myplugins.candy.colors')) -- works
    use(require('myplugins.candy.windows')) -- works
    -- use(require('myplugins.candy.silicon'))

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
