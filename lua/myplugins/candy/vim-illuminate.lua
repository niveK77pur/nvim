return {
    "RRethy/vim-illuminate",
    config = function()
        require("illuminate").configure({
            filetypes_denylist = { "lilypond" },
            modes_denylist = { "i" },
            min_count_to_highlight = 2,
        })
    end,
}
