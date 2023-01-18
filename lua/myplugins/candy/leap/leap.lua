return { 'ggandor/leap.nvim',
    config = function()
        local l = require('leap')
        -- vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = '#707070' })
        -- l.set_default_keymaps(true)
        l.add_default_mappings()

        -- target_windows = { vim.fn.win_getid() }
        -- require('leap').leap { target_windows = { vim.fn.win_getid() } }
        -- require('leap').leap { target_windows = vim.tbl_filter(
        --   function (win) return vim.api.nvim_win_get_config(win).focusable end,
        --   vim.api.nvim_tabpage_list_wins(0)
        -- )}
    end
}
