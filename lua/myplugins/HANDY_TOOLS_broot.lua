return {
    'lstwn/broot.vim',
    enabled = true,
    init = function()
        local conf = vim.fn.expand('~') .. '/.config/broot/conf.%s'
        vim.g.broot_default_conf_path = (vim.fn.filereadable(conf:format('toml')) == 1) and conf:format('toml')
            or conf:format('hjson')
    end,
    config = function()
        vim.keymap.set('n', '<Leader>b', '<cmd>Broot<cr>', { desc = 'broot.vim: Open :Broot' })
    end,
}
