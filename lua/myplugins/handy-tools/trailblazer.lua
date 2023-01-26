return {
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
        require("trailblazer").setup({
            mappings = {
                nv = { -- Mode union: normal & visual mode. Can be extended by adding i, x, ...
                    motions = {
                        new_trail_mark = '<A-l>',
                        track_back = '<A-k>',
                        peek_move_next_down = '<A-J>',
                        peek_move_previous_up = '<A-K>',
                        toggle_trail_mark_list = '<A-m>',
                    },
                    actions = {
                        delete_all_trail_marks = '<A-L>',
                        paste_at_last_trail_mark = '<A-p>',
                        paste_at_all_trail_marks = '<A-P>',
                        set_trail_mark_select_mode = '<A-t>',
                    },
                },
                -- You can also add/move any motion or action to mode specific mappings i.e.:
                -- i = {
                --     motions = {
                --         new_trail_mark = '<C-l>',
                --         ...
                --     },
                --     ...
                -- },
            },
        })
    end,
}