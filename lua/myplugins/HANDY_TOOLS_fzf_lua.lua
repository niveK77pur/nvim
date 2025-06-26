return {
    'ibhagwan/fzf-lua',
    dependencies = {
        -- 'nvim-tree/nvim-web-devicons',
        { 'junegunn/fzf', build = './install --xdg --all --no-fish' },
    },
    enabled = true,
    config = function()
        local fzflua = require('fzf-lua')
        fzflua.setup({
            keymap = {
                --  {{{
                builtin = {
                    -- neovim `:tmap` mappings for the fzf win
                    ['<F1>'] = 'toggle-help',
                    ['<F2>'] = 'toggle-fullscreen',
                    -- Only valid with the 'builtin' previewer
                    ['<F3>'] = 'toggle-preview-wrap',
                    ['<F4>'] = 'toggle-preview',
                    -- Rotate preview clockwise/counter-clockwise
                    ['<F5>'] = 'toggle-preview-ccw',
                    ['<F6>'] = 'toggle-preview-cw',
                    ['<c-f>'] = 'preview-page-down',
                    ['<c-b>'] = 'preview-page-up',
                    ['<c-h>'] = 'preview-page-reset',
                },
                fzf = {
                    -- fzf '--bind=' options
                    -- ["ctrl-u"] = "unix-line-discard",
                    ['ctrl-d'] = 'half-page-down',
                    ['ctrl-u'] = 'half-page-up',
                    ['ctrl-a'] = 'beginning-of-line',
                    ['ctrl-e'] = 'end-of-line',
                    ['alt-a'] = 'toggle-all',
                    -- Only valid with fzf previewers (bat/cat/git/etc)
                    ['f3'] = 'toggle-preview-wrap',
                    ['f4'] = 'toggle-preview',
                    ['ctrl-f'] = 'preview-page-down',
                    ['ctrl-b'] = 'preview-page-up',
                },
            }, --  }}}
            fzf_opts = {
                ['--layout'] = 'default',
            },
        })

        vim.keymap.set('n', '<Leader>fF', fzflua.builtin, {
            desc = 'FZF: builtin commands',
        })

        -- files
        -- vim.keymap.set('n', '<Leader>fr', function() fzflua.grep_project() end)
        vim.keymap.set('n', '<Leader>fr', function()
            fzflua.live_grep_native({ exec_empty_query = true })
        end, { desc = 'FZF: Live grep' })
        vim.keymap.set('n', '<Leader>ff', function()
            fzflua.files()
        end, { desc = 'FZF: Navigate files' })
        vim.keymap.set('n', '<Leader>fb', function()
            fzflua.buffers()
        end, { desc = 'FZF: Navigate buffers' })
        vim.keymap.set('n', '<Leader>fl', function()
            fzflua.blines()
        end, { desc = 'FZF: Navigate lines in buffer' })
        vim.keymap.set('n', '<Leader>fL', function()
            fzflua.lines()
        end, { desc = 'FZF: Navigate lines in all open buffers' })

        -- lists
        vim.keymap.set('n', '<Leader>fh', function()
            fzflua.helptags()
        end, { desc = 'FZF: Help tags' })
        if require('lazy.core.config').plugins['todo-comments.nvim'] == nil then
            vim.keymap.set('n', '<Leader>ft', function()
                fzflua.grep({ search = 'TODO|todo!', no_esc = true })
            end, { desc = 'FZF: search TODOs' })
        end

        -- suggestions
        vim.keymap.set('n', 'z=', function()
            fzflua.spell_suggest()
        end, { desc = 'FZF: spell suggestions' })

        -- Insert mode completion (also check junegunn/fzf.vim config)
        vim.keymap.set('i', '<Leader><c-x><c-f>', function()
            fzflua.complete_path()
        end, { desc = 'FZF: Complete path' })
        vim.keymap.set('i', '<Leader><c-x><c-l>', function()
            fzflua.complete_line()
        end, { desc = 'FZF: Complete line' })
        vim.keymap.set('i', '<Leader><c-x><c-L>', function()
            fzflua.complete_bline()
        end, { desc = 'FZF: Complete line (buffer local)' })

        -- treesitter / LSP / diagnostics
        vim.keymap.set('n', '<Leader>fgt', fzflua.treesitter, {
            desc = 'FZF: treesitter',
        })
        vim.keymap.set('n', 'grr', fzflua.lsp_references, {
            desc = 'FZF: lsp_references',
        })
        vim.keymap.set('n', 'gri', fzflua.lsp_implementations, {
            desc = 'FZF: lsp_implementations',
        })
        vim.keymap.set('n', 'gO', fzflua.lsp_document_symbols, {
            desc = 'FZF: lsp_document_symbols',
        })
        vim.keymap.set('n', 'gdl', fzflua.diagnostics_document, {
            desc = 'FZF: diagnostics_document',
        })
        vim.keymap.set('n', 'gdL', fzflua.diagnostics_workspace, {
            desc = 'FZF: diagnostics_workspace',
        })

        -- `:help vim.ui.select` for more info
        fzflua.register_ui_select()
        vim.cmd([[
            augroup fzflua
            au fzflua FileType java lua require('fzf-lua').deregister_ui_select()
        ]])
    end,
}

-- vim: fdm=marker
