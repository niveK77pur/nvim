vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[  ]]

local vimrc_path = vim.fn.stdpath('config') .. '/lua/vimrc'

for _, fname in ipairs(vim.fn.glob(vimrc_path .. '/**/*.lua', false, true)) do
    local name = vim.fs.relpath(vimrc_path, fname)
    if name == nil then
        print('Failed to get relative path for vimrc file: ' .. fname)
    else
        name = string.gsub(name, '%.lua$', '')
        name = string.gsub(name, '/', '.')
        require('vimrc.' .. name)
    end
end
