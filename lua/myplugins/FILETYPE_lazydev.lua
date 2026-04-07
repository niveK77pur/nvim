return {
    'folke/lazydev.nvim',
    enabled = true,
    ft = { 'lua' },
    opts = {
        library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
        enabled = function(root_dir)
            -- disable when a .luarc.json file is found
            return not vim.uv.fs_stat(root_dir .. '/.luarc.json')
        end,
    },
}
