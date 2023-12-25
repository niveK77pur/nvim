return {
    'luk400/vim-jukit',
    enabled = true,
    event = 'BufRead *.ipynb',
    init = function()
        -- disable default mappings
        vim.g.jukit_mappings = 0
    end,
    config = function()
        vim.cmd([[
            " Splits
            nnoremap <LocalLeader>os :call jukit#splits#output()<cr>
            nnoremap <LocalLeader>od :call jukit#splits#close_output_split()<cr>
            nnoremap <LocalLeader>So :call jukit#splits#show_last_cell_output(1)<cr>
            nnoremap <LocalLeader>Sl :call jukit#layouts#set_layout()<cr>
            " Sending code
            nnoremap <LocalLeader><space> :call jukit#send#section(0)<cr>
            nnoremap <LocalLeader>cc :call jukit#send#until_current_section()<cr>
            nnoremap <LocalLeader>ca :call jukit#send#all()<cr>
            nnoremap <LocalLeader><cr> :call jukit#send#line()<cr>
            vnoremap <LocalLeader><cr> :<C-U>call jukit#send#selection()<cr>
            " Cells
            nnoremap <LocalLeader>j :call jukit#cells#jump_to_next_cell()<cr>
            nnoremap <LocalLeader>k :call jukit#cells#jump_to_previous_cell()<cr>
            nnoremap <LocalLeader>co :call jukit#cells#create_below(0)<cr>
            nnoremap <LocalLeader>cO :call jukit#cells#create_above(0)<cr>
            nnoremap <LocalLeader>ct :call jukit#cells#create_below(1)<cr>
            nnoremap <LocalLeader>cT :call jukit#cells#create_above(1)<cr>
            nnoremap <LocalLeader>cd :call jukit#cells#delete()<cr>
            nnoremap <LocalLeader>cs :call jukit#cells#split()<cr>
            nnoremap <LocalLeader>cM :call jukit#cells#merge_above()<cr>
            nnoremap <LocalLeader>cm :call jukit#cells#merge_below()<cr>
            nnoremap <LocalLeader>ck :call jukit#cells#move_up()<cr>
            nnoremap <LocalLeader>cj :call jukit#cells#move_down()<cr>
            " ipynb conversion
            nnoremap <LocalLeader>np :call jukit#convert#notebook_convert("jupyter-notebook")<cr>
        ]])
    end,
}
