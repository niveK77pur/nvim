return {
    'jbyuki/instant.nvim',
    enabled = true,
    cmd = {
        'InstantStartServer',
        'InstantStartSingle',
        'InstantJoinSingle',
        'InstantStartSession',
        'InstantJoinSession',
    },
    config = function()
        vim.g.instant_username = 'MaceVimdu'
    end,
}
