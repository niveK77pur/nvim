return {
    'RRethy/vim-illuminate',
    enabled = true,
    lazy = false,
    keys = {
        {
            '<a-n>',
            function()
                require('illuminate').goto_next_reference()
            end,
        },
        {
            '<a-N>',
            function()
                require('illuminate').goto_prev_reference()
            end,
        },
    },
    config = function()
        require('illuminate').configure({
            filetypes_denylist = { 'lilypond' },
            modes_denylist = { 'i' },
            min_count_to_highlight = 2,
            disable_keymaps = true,
        })
    end,
}
