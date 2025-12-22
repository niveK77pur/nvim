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

        local augroup_instant = vim.api.nvim_create_augroup('instant', {})
        vim.api.nvim_create_autocmd({ 'BufWritePre', 'BufEnter' }, {
            group = augroup_instant,
            pattern = { '*' },
            desc = 'Prevent saving instant.nvim buffers',
            callback = function(args)
                -- If the client saves the synced buffer, then the syncing
                -- seems to break and the server only receives partial updates
                -- or junk.
                if vim.tbl_contains(require('instant').get_connected_buf_list(), args.buf) then
                    vim.notify(
                        string.format('Buffer %s should not be saved [%s]', args.buf, args.file),
                        vim.log.levels.WARN,
                        { title = 'instant.nvim', group = 'instant.nvim' }
                    )
                    vim.bo[args.buf].readonly = true
                end
            end,
        })
    end,
}
