-- NOTE: Load this first, as lazy.nvim modifies the 'runtimepath', which may
-- cause problems with :packadd calls happening before lazy.nvim

-- Bootstrap lazy.nvim {{{
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
--  }}}

require('lazy').setup('myplugins')
