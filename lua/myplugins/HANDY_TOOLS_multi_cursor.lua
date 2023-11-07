return { 'mg979/vim-visual-multi', branch = 'master',
    enabled = true,
    config = function()
        vim.g.VM_leader = [[\]]
        vim.g.VM_theme = 'iceblue'
        vim.g.VM_mouse_mappings = 1
        -- mouse mappings not working? :(
        vim.keymap.set('n', '<C-LeftMouse>', '<Plug>(VM-Mouse-Cursor)')
        vim.keymap.set('n', '<C-RightMouse>', '<Plug>(VM-Mouse-Word)')
        vim.keymap.set('n', '<M-C-RightMouse>', '<Plug>(VM-Mouse-Column)')
        vim.g.VM_maps = {
            -- https://github.com/mg979/vim-visual-multi/wiki/Quick-start#undoredo
            ["Undo"] = 'u',
            ["Redo"] = '<C-r>',
        }
    end,
}
