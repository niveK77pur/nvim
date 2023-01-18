local localrc = { 'thinca/vim-localrc', disable = true }

local exrc = { 'MunifTanjim/exrc.nvim', disable = false, -- local .nvimrc files
    requires = { 'MunifTanjim/nui.nvim', opt = true },
    config = function()
        -- disable built-in local config file support
        vim.o.exrc = false
        require("exrc").setup({
            files = {
                ".nvimrc.lua",
                ".nvimrc",
                ".exrc.lua",
                ".exrc",
            },
        })
    end,
}

return exrc
