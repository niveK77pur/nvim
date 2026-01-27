vim.opt.tabstop = 2

local augroup_ftplugin_json = vim.api.nvim_create_augroup('ftplugin_json', {})
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = augroup_ftplugin_json,
    pattern = { 'appwrite.config.json' },
    desc = 'appwrite json configuration',
    callback = function()
        vim.bo.tabstop = 4
    end,
})
