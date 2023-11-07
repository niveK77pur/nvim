return {
    'preservim/vim-pencil',
    enabled = true,
    ft = { 'tex', 'latex', 'text', 'clipboard' },
    keys = {
        { '<Leader>pt', ':PencilToggle<CR>' },
        { '<Leader>po', ':PencilOff<CR>' },
        { '<Leader>ph', ':PencilHard<CR>' },
        { '<Leader>ps', ':PencilSoft<CR>' },
    },
    config = function()
        -- vim.g['pencil#autoformat'] = 1
        -- vim.g['pencil#wrapModeDefault'] = 'hard'   -- default is 'hard'
        -- vim.g['pencil#textwidth'] = 74
        -- vim.g['pencil#cursorwrap'] = 1     -- 0=disable, 1=enable (def)
    end,
}
