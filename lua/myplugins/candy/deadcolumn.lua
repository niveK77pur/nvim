return {
    "Bekaboo/deadcolumn.nvim",
    enabled = true,
    event = { 'ColorScheme' },
    opts = {
        modes = { 'i', 'n' },
        blending = {
            threshold = 2/3,
            colorcode = "#202330", -- pinkmare s:palette.bg0
        },
        extra = {
            follow_tw = "+0",
        }
    },
}

-- vim: cc=25 tw=35
