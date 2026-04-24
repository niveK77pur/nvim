-- navigate windows with CTRL+ALT+{h,j,k,l}
vim.keymap.set({ 't', 'i', 'n' }, '<C-A-h>', [[<C-\><C-N><C-w>h]], { desc = 'Navigate window using ALT+h' })
vim.keymap.set({ 't', 'i', 'n' }, '<C-A-j>', [[<C-\><C-N><C-w>j]], { desc = 'Navigate window using ALT+j' })
vim.keymap.set({ 't', 'i', 'n' }, '<C-A-k>', [[<C-\><C-N><C-w>k]], { desc = 'Navigate window using ALT+k' })
vim.keymap.set({ 't', 'i', 'n' }, '<C-A-l>', [[<C-\><C-N><C-w>l]], { desc = 'Navigate window using ALT+l' })

-- use ALT+{, .} to navigate tabs
vim.keymap.set({ 't', 'i', 'n' }, '<A-,>', [[<C-\><C-N>:tabprevious<CR>]], { desc = 'Navigate tabs using ALT+,' })
vim.keymap.set({ 't', 'i', 'n' }, '<A-.>', [[<C-\><C-N>:tabnext<CR>]], { desc = 'Navigate tabs using ALT+.' })

-- use arrow keys to move linewise on wrapped lines
vim.keymap.set('n', '<up>', 'g<up>')
vim.keymap.set('n', '<down>', 'g<down>')
vim.keymap.set('i', '<up>', '<c-o>g<up>')
vim.keymap.set('i', '<down>', '<c-o>g<down>')

-- " use ALT+{h,j,k,l} to move cursor in insert mode
vim.keymap.set('i', '<a-h>', '<left>')
vim.keymap.set('i', '<a-j>', '<c-o>g<down>')
vim.keymap.set('i', '<a-k>', '<c-o>g<up>')
vim.keymap.set('i', '<a-l>', '<right>')
