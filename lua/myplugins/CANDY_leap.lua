return {
    'ggandor/leap.nvim',
    enabled = true,
    config = function()
        local l = require('leap')
        vim.schedule(function()
            vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Conceal' })
        end)
        -- l.set_default_keymaps(true)
        l.add_default_mappings()

        -- target_windows = { vim.fn.win_getid() }
        -- require('leap').leap { target_windows = { vim.fn.win_getid() } }
        -- require('leap').leap { target_windows = vim.tbl_filter(
        --   function (win) return vim.api.nvim_win_get_config(win).focusable end,
        --   vim.api.nvim_tabpage_list_wins(0)
        -- )}

        -- Bidirectional search. Initiate multi-window mode with the current
        -- window as the only target.
        -- vim.keymap.set(
        --     { "n" }, "s",
        --     function()
        --         require('leap').leap({ target_windows = { vim.fn.win_getid() } })
        --     end,
        --     {
        --         desc = "Bidirectional search. Initiate " ..
        --             "multi-window mode with the current window as the only " ..
        --             "target"
        --     }
        -- )
    end,
}
