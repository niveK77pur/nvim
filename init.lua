vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[  ]]

local vimrc_files = {
    'vimrc.notify',
    'vimrc.functions',
    'vimrc.mappings',
    'vimrc.plugins',
    'vimrc.settings',
    'vimrc.commands',
    'vimrc.autocommands',
    'vimrc.neovide',
    'vimrc.filetypes',
}

for _, vfile in pairs(vimrc_files) do
    require(vfile)
end
