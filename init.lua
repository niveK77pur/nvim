vim.g.mapleader = 'é'
vim.g.maplocalleader = 'è'

vim.keymap.set({ 'i', 'n' }, [[<Leader><Leader>]], [[<Leader>]])
vim.keymap.set({ 'i', 'n' }, [[<LocalLeader><LocalLeader>]], [[<LocalLeader>]])

local vimrc_files = {
	'vimrc.functions',
	'vimrc.mappings',
	'vimrc.plugin-settings',
	'vimrc.plugins',
	'vimrc.settings',
}

for _,vfile in pairs(vimrc_files) do
	require(vfile)
end
