-- https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/

vim.keymap.set("n", "<Leader>ee", ":Lexplore %:p:h<CR>")
vim.keymap.set("n", "<Leader>ep", ":Lexplore<CR>")
vim.keymap.set("n", "qq", ":Lexplore<CR>")

-- go back in history
vim.keymap.set("n", "H", "u", { buffer = true })

-- move up a directory
vim.keymap.set('n', 'h', '-^', { buffer = true })

-- hide dot files
vim.keymap.set('n', '.', 'gh', { buffer = true })

-- close preview
vim.keymap.set('n', 'P', '<c-w>z', { buffer = true })

-- easier motion into files/directories
vim.keymap.set('n', 'l', '<CR>', { buffer = true })
vim.keymap.set('n', 'L', '<CR>:Lexplore<CR>', { buffer = true })
