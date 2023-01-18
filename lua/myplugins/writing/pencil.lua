return { 'preservim/vim-pencil', disable = false, -- {{{
    ft = { 'tex', 'latex', 'text', 'clipboard' },
    config = function()
        local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
        -- vim.g['pencil#autoformat'] = 1
        -- vim.g['pencil#wrapModeDefault'] = 'hard'   -- default is 'hard'
        -- vim.g['pencil#textwidth'] = 74
        -- vim.g['pencil#cursorwrap'] = 1     -- 0=disable, 1=enable (def)

        nmap('<Leader>pt', ':PencilToggle<CR>')
        nmap('<Leader>po', ':PencilOff<CR>')
        nmap('<Leader>ph', ':PencilHard<CR>')
        nmap('<Leader>ps', ':PencilSoft<CR>')
    end,
} -- }}}
