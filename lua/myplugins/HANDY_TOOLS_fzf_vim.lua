return {
    'junegunn/fzf.vim',
    enabled = false,
    config = function()
        vim.g.fzf_preview_window = { 'right,50%,<70(up,40%)', 'alt-p' }

        local nmap = function(LH, RH, args)
            vim.keymap.set('n', LH, RH, args)
        end
        local imap = function(LH, RH, args)
            vim.keymap.set('i', LH, RH, args)
        end

        -- FZF Commands
        nmap('<Leader>fr', ':Rg<CR>')
        nmap('<Leader>ff', ':Files<CR>')
        nmap('<Leader>fg', ':GFiles<CR>')
        nmap('<Leader>fb', ':Buffers<CR>')
        nmap('<Leader>fl', ':BLines<CR>')
        nmap('<Leader>fL', ':Lines<CR>')
        nmap('<Leader>fh', ':Helptags<CR>')
        nmap('<Leader>fm', ':Marks<CR>')
        nmap('<Leader>f:', ':History:<CR>')
        nmap('<Leader>f/', ':History/:<CR>')
        nmap('<Leader>fs', ':Snippets:<CR>')

        -- Insert mode completion
        imap('<c-x><c-k>', '<plug>(fzf-complete-word)')
        imap('<c-x><c-f>', '<plug>(fzf-complete-path)')
        imap('<c-x><c-j>', '<plug>(fzf-complete-file-ag)')
        imap('<c-x><c-l>', '<plug>(fzf-complete-line)')
        imap('<c-x><c-L>', '<plug>(fzf-complete-buffer-line)')

        vim.cmd([[
            " Mapping selecting mappings
            nmap <leader><tab> <plug>(fzf-maps-n)
            "imap <leader><tab> <plug>(fzf-maps-i)
            xmap <leader><tab> <plug>(fzf-maps-x)
            omap <leader><tab> <plug>(fzf-maps-o)
        ]])
    end,
}
