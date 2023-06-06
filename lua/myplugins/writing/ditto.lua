return { 'dbmrq/vim-ditto',
    enabled = true,
    ft = { 'tex', 'latex', 'text', 'markdown' },
    config = function()
        local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end

        -- Turn Ditto on and off
        nmap('<Leader>dt', '<Plug>ToggleDitto')
        -- Jump to the next word
        nmap('<Leader>dn', '<Plug>DittoNext')
        -- Jump to the previous word
        nmap('<Leader>dp', '<Plug>DittoPrev')
        -- Ignore the word under the cursor
        nmap('<Leader>d+', '<Plug>DittoGood')
        -- Stop ignoring the word under the cursor
        nmap('<Leader>d-', '<Plug>DittoBad')
        -- Show the next matches
        nmap('<Leader>d>', '<Plug>DittoMore')
        -- Show the previous matches
        nmap('<Leader>d<', '<Plug>DittoLess')

        vim.cmd [[
            augroup ditto
            autocmd!
            au FileType markdown,text,tex,latex DittoOn
            augroup END
        ]]
    end,
}
