return {
    'anuvyklack/windows.nvim',
    dependencies = {
        'anuvyklack/middleclass',
        'anuvyklack/animation.nvim',
    },
    enabled = true,
    keys = {
        { '<Leader>we', '<cmd>WindowsEnableAutowidth<CR>' },
        { '<Leader>wd', '<cmd>WindowsDisableAutowidth<CR>' },
        { '<Leader>wt', '<cmd>WindowsToggleAutowidth<CR>' },
        { '<Leader>wm', '<cmd>WindowsMaximaze<CR>' },
    },
    cmd = {
        'WindowsEnableAutowidth',
        'WindowsToggleAutowidth',
        'WindowsMaximaze',
    },
    config = function()
        local width = 10
        vim.o.winwidth = width
        vim.o.winminwidth = width
        vim.o.equalalways = false

        require('windows').setup({
            autowidth = {
                winwidth = 0.7,
            },
            animation = {
                enable = true,
                duration = 150,
                -- fps = 30,
            },
        })
    end,
}
