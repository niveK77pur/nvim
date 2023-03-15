return { 'EdenEast/nightfox.nvim',
    build = ":NightfoxCompile",
    config = function()

        require('nightfox').setup({
            options = {
                transparent = false, -- Disable setting background
                dim_inactive = true,
                styles = {
                    comments = "italic",
                },
                inverse = {             -- Inverse highlight for different types
                    match_paren = false,
                    visual = false,
                    search = false,
                },
            },
        })

        vim.cmd( ('colorscheme %sfox'):format(
            ({ 'night','day','dawn','dusk','nord','tera','carbon' })[4]
            --   111  , 222 , 3333 , 4444 , 5555 , 6666 , 777777
        ) )

    end,
}
