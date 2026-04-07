vim.opt.wrap = true

for _, key in pairs({ 'j', 'k', '0', '$' }) do
    vim.keymap.set('n', key, 'g' .. key, { desc = string.format('remap %s for better text editing', key) })
end
