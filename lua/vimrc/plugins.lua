-- Bootstrap lazy.nvim {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
--  }}}

require('lazy').setup({

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                 Interface
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    require('myplugins.interface.colorscheme'),

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                Handy Tools
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    require('myplugins.handy-tools.localrc'),
    require('myplugins.handy-tools.multi-cursor'),
    require('myplugins.handy-tools.printer'),
    require('myplugins.handy-tools.trailblazer'),

    -- require('myplugins.handy-tools.telescope'),
    require('myplugins.handy-tools.fzf-lua'),
    require('myplugins.handy-tools.fzf-vim'),

    require('myplugins.handy-tools.snippets'),

    require('myplugins.handy-tools.gitsigns'),
    require('myplugins.handy-tools.treesitter-context'),

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                  Writing
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    require('myplugins.writing.pencil'),
    require('myplugins.writing.ditto'),

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                  Editing
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    require('myplugins.editing.comment'),
    require('myplugins.editing.auto-pairs'),
    require('myplugins.editing.surround'),
    require('myplugins.editing.vim-easy-align'),
    require('myplugins.editing.vim-exchange'),
    -- require('myplugins.editing.vim-move'),
    -- require('myplugins.editing.ssr'),
    require('myplugins.editing.ts-node-action'),

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                   Music
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                             Language Support
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    require('myplugins.language-support.treesitter'),
    require('myplugins.language-support.BetterLua'),

    require('myplugins.language-support.nvim-lilypond-suite'),
    require('myplugins.language-support.vimtex'),

    -- require('myplugins.language-support.vim-diagram'),
    require('myplugins.language-support.vim-jukit'),

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                               Collaboration
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- require('myplugins.collaboration.instant'),

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                              Language Server
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    -- require('myplugins.language-server.coc'),
    require('myplugins.language-server.lsp-zero'),
    require('myplugins.language-server.nvim-cmp'),

    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    --                                   Candy
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    require('myplugins.candy.ghost'),

    require('myplugins.candy.vim-floaterm'),
    require('myplugins.candy.nui'),

    require('myplugins.candy.fold'),
    require('myplugins.candy.leap'),

    require('myplugins.candy.colors'),
    require('myplugins.candy.windows'),
    -- require('myplugins.candy.silicon'),

})
-- vim: fdm=marker
