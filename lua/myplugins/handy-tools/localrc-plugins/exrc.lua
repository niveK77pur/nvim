return { 'MunifTanjim/exrc.nvim',
    enabled = true,
    dependencies = { 'MunifTanjim/nui.nvim', lazy = true },
    config = function()
        -- disable built-in local config file support
        vim.o.exrc = false
        require("exrc").setup({
            files = {
                ".nvimrc.lua",
                ".nvim.lua",
                ".nvimrc",
                ".exrc.lua",
                ".exrc",
            },
        })
    end,
}
