return {
    'matsuuu/pinkmare',
    enabled = false,
    config = function()
        vim.g.pinkmare_transparent_background = true
        vim.g.pinkmare_overwrite_groups = {
            -- ['@string'] = {
            --     fg = { '#FF38A2', '167', 'Red' },
            --     bg = { '#FAE8B6', '223', 'White' },
            -- },
            -- String = {
            --     bg = { '#87c095', '108', 'Cyan' },
            -- },
            TabLineSel = {
                bg = vim.fn['pinkmare#get_palette']().bg1,
            },
        }
        vim.cmd('colorscheme pinkmare')
    end,
}
