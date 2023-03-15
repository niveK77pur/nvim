return { "anuvyklack/windows.nvim",
    dependencies = {
        "anuvyklack/middleclass",
        "anuvyklack/animation.nvim"
    },
    cmd = { 'WindowsEnableAutowidth', 'WindowsToggleAutowidth', 'WindowsMaximaze', },
    config = function()
        local width = 10
        vim.o.winwidth = width
        vim.o.winminwidth = width
        vim.o.equalalways = false

        require('windows').setup{
            animation = {
                enable = true,
                duration = 150,
                -- fps = 30,
            }
        }

        local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
        nmap('<Leader>we', '<cmd>WindowsEnableAutowidth<CR>')
        nmap('<Leader>wd', '<cmd>WindowsDisableAutowidth<CR>')
        nmap('<Leader>wt', '<cmd>WindowsToggleAutowidth<CR>')
        nmap('<Leader>wm', '<cmd>WindowsMaximaze<CR>')
    end
}
