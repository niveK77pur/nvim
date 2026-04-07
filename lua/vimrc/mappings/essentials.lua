vim.keymap.set('i', 'jk', '<esc>', { desc = 'exit intert mode more comfortably' })

vim.keymap.set('n', '<Leader>s', '<cmd>wa<cr>', { desc = 'save files' })

vim.keymap.set('n', '<Leader>{', function()
    local cs = vim.o.commentstring
    cs = cs:gsub('%%[^s]', '%%%0') -- % -> %%
    vim.fn.append('.', { cs:format(' {{{'), cs:format(' }}}') })
end, {
    desc = "add '{{{' and '}}}' markings for folding",
})

vim.keymap.set({ 'n', 'v', 'o' }, '<F5>', ':set wrap! wrap?<CR>', { desc = 'Toggle line wrapping' })

vim.keymap.set('n', '<Leader>hs', ':set hlsearch! hlsearch?<CR>')
vim.keymap.set('n', '<Leader>hl', ':set cursorline! cursorline?<CR>')
vim.keymap.set('n', '<Leader>hc', ':set cursorcolumn! cursorcolumn?<CR>')

vim.keymap.set('n', '<F12>', [[:echo '\°O°/'<CR>]])

vim.keymap.set('n', 'grd', '<c-]>', {
    desc = '<c-]> but matching the default LSP mappings',
    noremap = false,
})
