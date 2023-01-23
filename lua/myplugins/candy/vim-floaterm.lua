return { 'voldikss/vim-floaterm',
    -- cmd = { 'FloatermNew' },
    config = function()
        local map = vim.keymap.set

        map('n', '<Leader><m-l>', ':FloatermNew --width=0.8 --height=0.8 --title=lazygit lazygit<CR>', {
            desc = 'FloatTerm with LazyGit',
        })

    end
}
