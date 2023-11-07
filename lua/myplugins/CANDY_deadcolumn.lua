return {
    "Bekaboo/deadcolumn.nvim",
    -- branch = "dev",
    enabled = true,
    -- event = { 'ColorScheme' },
    opts = {
        modes = { 'i', 'n' },
        blending = {
            threshold = 2/3,
            colorcode = "#202330", -- pinkmare s:palette.bg0
        },
        extra = {
            follow_tw = "+1",
        }
    },
}

-- vim: cc=15 tw=35
