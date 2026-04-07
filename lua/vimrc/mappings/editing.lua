vim.keymap.set('n', '<Leader>ve', function()
    require('fzf-lua').files({ cwd = vim.fn.stdpath('config') .. '/lua/vimrc' })
end, { desc = 'edit vimrc files' })

vim.keymap.set('n', '<Leader>vp', function()
    require('fzf-lua').files({ cwd = vim.fn.stdpath('config') .. '/lua/myplugins' })
end, { desc = 'edit plugin files' })

vim.keymap.set('n', '<Leader>F', function()
    vim.cmd(('tabnew %s/ftplugin/%s.lua'):format(vim.fn.stdpath('config'), vim.o.filetype))
end, { desc = 'edit filetype plugin of current filetype' })

vim.keymap.set('n', '<Leader>gf', '<cmd>e <cfile><CR>', { desc = "'gf' but make it create new file if not existent" })

vim.keymap.set('i', '<A-p>', '<c-r>"', { desc = 'paste text in " register more easily in insert mode' })
