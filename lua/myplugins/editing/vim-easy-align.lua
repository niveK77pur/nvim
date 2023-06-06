return { 'junegunn/vim-easy-align',
    enabled = true,
    config = function()
        local map = function(mode, LH, RH, args) vim.keymap.set(mode, LH, RH, args) end

        -- https://github.com/junegunn/vim-easy-align#1-plug-mappings-interactive-mode
        map({'n','x'}, '<Leader>a', '<Plug>(EasyAlign)')

        -- https://github.com/junegunn/vim-easy-align#disabling-foldmethod-during-alignment
        vim.g.easy_align_bypass_fold = 1
    end,
}
