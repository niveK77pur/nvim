local nmap = function(LH, RH, args)
    vim.keymap.set('n', LH, RH, args)
end

vim.opt.wrap = true

for _, key in pairs({ 'j', 'k', '0', '$' }) do
    nmap(key, 'g' .. key, { desc = string.format('remap %s for better text editing', key) })
end
