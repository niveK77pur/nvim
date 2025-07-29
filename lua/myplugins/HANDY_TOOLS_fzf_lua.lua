return {
    'ibhagwan/fzf-lua',
    dependencies = {
        -- 'nvim-tree/nvim-web-devicons',
        { 'junegunn/fzf', build = './install --xdg --all --no-fish' },
    },
    enabled = true,
    keys = {

        {
            '<Leader>fF',
            function()
                require('fzf-lua').builtin()
            end,
            desc = 'FZF: builtin commands',
        },

        -- files
        -- {'<Leader>fr', function() fzflua.grep_project() end},
        {
            '<Leader>fr',
            function()
                require('fzf-lua').live_grep_native({ exec_empty_query = true })
            end,
            desc = 'FZF: Live grep',
        },
        {
            '<Leader>ff',
            function()
                require('fzf-lua').files()
            end,
            desc = 'FZF: Navigate files',
        },
        {
            '<Leader>fb',
            function()
                require('fzf-lua').buffers()
            end,
            desc = 'FZF: Navigate buffers',
        },
        {
            '<Leader>fl',
            function()
                require('fzf-lua').blines()
            end,
            desc = 'FZF: Navigate lines in buffer',
        },
        {
            '<Leader>fL',
            function()
                require('fzf-lua').lines()
            end,
            desc = 'FZF: Navigate lines in all open buffers',
        },

        -- lists
        {
            '<Leader>fh',
            function()
                require('fzf-lua').helptags()
            end,
            desc = 'FZF: Help tags',
        },
        -- '<Leader>ft',

        -- suggestions
        {
            'z=',
            function()
                require('fzf-lua').spell_suggest()
            end,
            desc = 'FZF: spell suggestions',
        },

        -- Insert mode completion (also check junegunn/fzf.vim config)
        {
            '<c-x><c-f>',
            function()
                require('fzf-lua').complete_path()
            end,
            mode = 'i',
            desc = 'FZF: Complete path',
        },
        {
            '<c-x><c-l>',
            function()
                require('fzf-lua').complete_line()
            end,
            mode = 'i',
            desc = 'FZF: Complete line',
        },
        {
            '<c-x><c-L>',
            function()
                require('fzf-lua').complete_bline()
            end,
            mode = 'i',
            desc = 'FZF: Complete line (buffer local)',
        },

        -- LSP / diagnostics
        {
            'grr',
            function()
                require('fzf-lua').lsp_references()
            end,
            desc = 'FZF: lsp_references',
        },
        {
            'gri',
            function()
                require('fzf-lua').lsp_implementations()
            end,
            desc = 'FZF: lsp_implementations',
        },
        {
            'gO',
            function()
                require('fzf-lua').lsp_document_symbols()
            end,
            desc = 'FZF: lsp_document_symbols',
        },
        {
            'gdl',
            function()
                require('fzf-lua').diagnostics_document()
            end,
            desc = 'FZF: diagnostics_document',
        },
        {
            'gdL',
            function()
                require('fzf-lua').diagnostics_workspace()
            end,
            desc = 'FZF: diagnostics_workspace',
        },
    },
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

        -- lists
        if require('lazy.core.config').plugins['todo-comments.nvim'] == nil then
            vim.keymap.set('n', '<Leader>ft', function()
                fzflua.grep({ search = 'TODO|todo!', no_esc = true })
            end, { desc = 'FZF: search TODOs' })
        end

        -- `:help vim.ui.select` for more info
        fzflua.register_ui_select()
        vim.cmd([[
            augroup fzflua
            au fzflua FileType java lua require('fzf-lua').deregister_ui_select()
        ]])
    end,
}

-- vim: fdm=marker
