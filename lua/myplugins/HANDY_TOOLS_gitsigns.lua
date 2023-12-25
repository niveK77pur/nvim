return {
    'lewis6991/gitsigns.nvim',
    enabled = true,
    config = function()
        require('gitsigns').setup({
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation {{{1
                map('n', ']c', function()
                    if vim.wo.diff then
                        return ']c'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true })

                map('n', '[c', function()
                    if vim.wo.diff then
                        return '[c'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true })

                -- Actions {{{1
                map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>')
                map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>')
                map(
                    'n',
                    '<leader>ghS',
                    gs.stage_buffer,
                    { desc = 'Gitsigns: Stage buffer' }
                )
                map(
                    'n',
                    '<leader>ghR',
                    gs.reset_buffer,
                    { desc = 'Gitsigns: Reset buffer' }
                )
                map(
                    'n',
                    '<leader>ghu',
                    gs.undo_stage_hunk,
                    { desc = 'Gitsigns: undo stage hunk' }
                )
                map(
                    'n',
                    '<leader>ghp',
                    gs.preview_hunk,
                    { desc = 'Gitsigns: preview hunk' }
                )
                map('n', '<leader>ghb', function()
                    gs.blame_line({ full = true })
                end, { desc = 'Gitsigns: Blame line' })
                map(
                    'n',
                    '<leader>gtb',
                    gs.toggle_current_line_blame,
                    { desc = 'Gitsigns: toggle current line blame' }
                )
                map(
                    'n',
                    '<leader>ghd',
                    gs.diffthis,
                    { desc = 'Gitsigns: diff this' }
                )
                map('n', '<leader>ghD', function()
                    gs.diffthis('~')
                end, { desc = 'Gitsigns: diff this ~' })
                map(
                    'n',
                    '<leader>gtd',
                    gs.toggle_deleted,
                    { desc = 'Gitsigns: toggle showing deleted lines' }
                )

                -- Text object {{{1
                map({ 'o', 'x' }, 'gih', ':<C-U>Gitsigns select_hunk<CR>')

                -- }}}1
            end,
        })
    end,
}
