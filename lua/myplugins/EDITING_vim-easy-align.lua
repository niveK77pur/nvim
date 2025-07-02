return {
    'junegunn/vim-easy-align',
    enabled = true,
    keys = {
        -- https://github.com/junegunn/vim-easy-align#1-plug-mappings-interactive-mode
        { 'ga', '<Plug>(EasyAlign)', mode = { 'n', 'x' } },
    },
    config = function()
        -- https://github.com/junegunn/vim-easy-align#disabling-foldmethod-during-alignment
        vim.g.easy_align_bypass_fold = 1
    end,
}
