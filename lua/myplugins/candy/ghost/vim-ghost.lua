return { 'raghur/vim-ghost', disable=true,
    run = ':GhostInstall',
    cmd = { 'GhostInstall', 'GhostStart' },
    config = function()
        vim.cmd [[
            function! s:SetupGhostBuffer()
                " mappings
                nmap <buffer> ZZ :%bdelete!<CR>

                " settings
                CocDisable
                set autowriteall

                " site specific settings
                let l:fname = expand("%:a")
                if l:fname =~# '\v/ghost-(github|reddit)\.com-'
                    set ft=markdown
                elseif l:fname =~# '/ghost-localhost.*jupyter-'
                    set ft=python
                    set tw=0
                elseif l:fname =~# '/ghost-www.overleaf'
                    set ft=tex
                    set tw=0
                    set ts=4 sw=0
                endif
            endfunction

            augroup vim-ghost
                au!
                au User vim-ghost#connected call s:SetupGhostBuffer()
            augroup END
        ]]
    end,
}
