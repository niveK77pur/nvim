return {
    'neoclide/coc.nvim',
    branch = 'release',
    enabled = false,
    build = ':CocUpdate',
    config = function()
        local map = function(mode, LH, RH, args)
            vim.keymap.set(mode, LH, RH, args)
        end

        vim.g.coc_global_extensions = {
            'coc-json',
            -- 'coc-lua',
            'coc-sumneko-lua',
            'coc-jedi',
            'coc-clangd',
            'coc-sh',
            'coc-vimlsp',
            'coc-vimtex',
            'coc-ultisnips',
            'coc-syntax',
            'coc-emoji',
            'coc-dictionary',
        }

        -- Use <c-space> to trigger completion.
        map('i', '<c-space>', 'coc#refresh()', { silent = true, expr = true })

        -- Remap <C-f> and <C-b> for scroll float windows/popups.
        map(
            { 'n', 'v' },
            '<C-f>',
            [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]],
            { silent = true, nowait = true, expr = true }
        )
        map(
            { 'n', 'v' },
            '<C-b>',
            [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]],
            { silent = true, nowait = true, expr = true }
        )
        map(
            'i',
            '<C-f>',
            [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"]],
            { silent = true, nowait = true, expr = true }
        )
        map(
            'i',
            '<C-b>',
            [[coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"]],
            { silent = true, nowait = true, expr = true }
        )

        -- Symbol renaming.
        map('n', '<leader>Cr', '<Plug>(coc-rename)', { silent = true })

        -- Use `[g` and `]g` to navigate diagnostics
        -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
        map('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
        map('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })

        -- GoTo code navigation.
        map('n', '<Leader>Cgd', '<Plug>(coc-definition)', { silent = true })
        map('n', '<Leader>Cgy', '<Plug>(coc-type-definition)', { silent = true })
        map('n', '<Leader>Cgi', '<Plug>(coc-implementation)', { silent = true })
        map('n', '<Leader>Cgr', '<Plug>(coc-references)', { silent = true })

        -- Formatting selected code.
        map({ 'x', 'n' }, '<Leader>Cf', '<Plug>(coc-format-selected)')

        -- vim.api.nvim_set_hl
        vim.cmd([[
            highlight link CocErrorVirtualText Exception
            highlight link CocWarningVirtualText Type
            " highlight link CocInfoVirtualText Special
            highlight link CocHintVirtualText Macro
        ]])
    end,
}
