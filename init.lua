vim.g.mapleader = 'é'
vim.g.maplocalleader = 'è'

vim.keymap.set({ 'i', 'n' }, [[<Leader><Leader>]], [[<Leader>]])
vim.keymap.set({ 'i', 'n' }, [[<LocalLeader><LocalLeader>]], [[<LocalLeader>]])

local vimrc_files = {
    'vimrc.notify',
    'vimrc.functions',
    'vimrc.mappings',
    'vimrc.plugins',
    'vimrc.settings',
    'vimrc.commands',
    'vimrc.autocommands',
}

for _, vfile in pairs(vimrc_files) do
    require(vfile)
end
