return { 'lervag/vimtex',
    enabled = true,
    ft = { 'latex', 'tex', 'plaintex', 'context', 'bib' },
    config = function()
        local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
        -- Settings --
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_fold_enabled = 1
        vim.g.tex_conceal = 'adbmgs'

        -- Mappings --
        nmap('<LocalLeader>ls', '<plug>(vimtex-compile-ss)')
        nmap('<LocalLeader>cw', ':VimtexCountWords<CR>')
        nmap('<LocalLeader>cl', ':VimtexCountLetters<CR>')

        -- Latex Documentation --
        -- vim.cmd [[
        --     let g:vimtex_doc_handlers = ['TexdocHandler']
        --     function! TexdocHandler(context)
        --     call vimtex#doc#make_selection(a:context)
        --     if !empty(a:context.selected)
        --         silent execute '!texdoc' a:context.selected '&'
        --     endif
        --     return 1
        --     endfunction
        -- ]]

        -- Warnings to ignore --
        vim.g.vimtex_quickfix_ignore_filters = {
            'Underfull',
            'Overfull',
            -- 'Font Warning:',
            'Empty bibliography',
            -- 'LaTeX hooks Warning: Generic hook',
            'Package hyperref Warning: Draft mode on.',
            -- 'siunitx/group-digits',
            -- ['overfull'] = 0,
            -- ['underfull'] = 0,
            -- ['packages'] = {
            --    ['hyperref'] = 0,
            -- },
        }
    end,
}
