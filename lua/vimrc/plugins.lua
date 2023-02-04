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
local configlua = vim.fn.stdpath('config') .. '/lua'
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup_packer_user_config,
    pattern = {
        configlua .. '/vimrc/plugins.lua',
        configlua .. '/myplugins/**/*.lua'
    },
    desc = "automatically :PackerCompile when file is written",
    callback = function()
        vim.cmd[[source <afile> | PackerCompile]]
        -- vim.cmd('source ' .. configlua .. '/vimrc/plugins.lua | PackerCompile')
    end,
})
--  }}}

return require('packer').startup({function(use)

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                 Interface
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.interface.colorscheme'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                Handy Tools
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.handy-tools.localrc'))
    use(require('myplugins.handy-tools.multi-cursor'))
    use(require('myplugins.handy-tools.printer'))
    use(require('myplugins.handy-tools.trailblazer'))

    -- use(require('myplugins.handy-tools.telescope'))
    use(require('myplugins.handy-tools.fzf-lua'))
    -- use(require('myplugins.handy-tools.fzf-vim'))

    use(require('myplugins.handy-tools.snippets'))

    use(require('myplugins.handy-tools.gitsigns'))
    use(require('myplugins.handy-tools.treesitter-context'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                  Writing
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.writing.pencil'))
    use(require('myplugins.writing.ditto'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                  Editing
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.editing.comment'))
    use(require('myplugins.editing.auto-pairs'))
    use(require('myplugins.editing.surround'))
    use(require('myplugins.editing.vim-easy-align'))
    use(require('myplugins.editing.vim-exchange'))
    -- use(require('myplugins.editing.vim-move'))
    -- use(require('myplugins.editing.ssr'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                   Music
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                             Language Support
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.language-support.treesitter'))
    use(require('myplugins.language-support.BetterLua'))

    use(require('myplugins.language-support.nvim-lilypond-suite'))
    use(require('myplugins.language-support.vimtex'))

    -- use(require('myplugins.language-support.vim-diagram'))
    use(require('myplugins.language-support.vim-jukit'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                               Collaboration
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- use(require('myplugins.collaboration.instant'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                              Language Server
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- use(require('myplugins.language-server.coc'))
    use(require('myplugins.language-server.lsp-zero'))
    use(require('myplugins.language-server.nvim-cmp'))

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                   Candy
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    use(require('myplugins.candy.ghost'))

    use(require('myplugins.candy.vim-floaterm'))
    use(require('myplugins.candy.nui'))

    use(require('myplugins.candy.fold'))
    use(require('myplugins.candy.leap'))

    use(require('myplugins.candy.colors'))
    use(require('myplugins.candy.windows'))
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
