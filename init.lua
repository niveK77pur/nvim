vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[  ]]

local vimrc_files = {
    'vimrc.mappings',
    'vimrc.plugins',
    'vimrc.settings',
    'vimrc.autocommands',
    'vimrc.neovide',
    'vimrc.filetypes',
}

for _, vfile in pairs(vimrc_files) do
    require(vfile)
end
