return {
    'voldikss/vim-floaterm',
    enabled = false,
    -- cmd = { 'FloatermNew' },
    keys = {

        {
            '<Leader><m-l>',
            ':FloatermNew --width=0.8 --height=0.8 --title=lazygit lazygit<CR>',
            desc = 'FloatTerm with LazyGit',
            mode = 'n',
        },
    },
}
