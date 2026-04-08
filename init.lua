vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[  ]]

for fname, type in vim.fs.dir(vim.fn.stdpath('config') .. '/lua/vimrc', { depth = math.huge }) do
    if type == 'file' and vim.fs.ext(fname) == 'lua' then
        local name = string.gsub(fname, '%.lua$', '')
        name = string.gsub(name, '/', '.')
        require('vimrc.' .. name)
    end
end
