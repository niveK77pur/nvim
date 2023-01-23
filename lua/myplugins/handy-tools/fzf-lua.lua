return { 'ibhagwan/fzf-lua',
    requires = {
        -- 'nvim-tree/nvim-web-devicons',
        { 'junegunn/fzf', run = './install --xdg --all' },
    },
    config = function()
        local fzflua = require('fzf-lua')
        fzflua.setup {
            keymap = { --  {{{
                builtin = {
                    -- neovim `:tmap` mappings for the fzf win
                    ["<F1>"]  = "toggle-help",
                    ["<F2>"]  = "toggle-fullscreen",
                    -- Only valid with the 'builtin' previewer
                    ["<F3>"]  = "toggle-preview-wrap",
                    ["<F4>"]  = "toggle-preview",
                    -- Rotate preview clockwise/counter-clockwise
                    ["<F5>"]  = "toggle-preview-ccw",
                    ["<F6>"]  = "toggle-preview-cw",
                    ["<c-d>"] = "preview-page-down",
                    ["<c-u>"] = "preview-page-up",
                    ["<c-h>"] = "preview-page-reset",
                },
                fzf = {
                    -- fzf '--bind=' options
                    -- ["ctrl-u"] = "unix-line-discard",
                    ["ctrl-f"] = "half-page-down",
                    ["ctrl-b"] = "half-page-up",
                    ["ctrl-a"] = "beginning-of-line",
                    ["ctrl-e"] = "end-of-line",
                    ["alt-a"]  = "toggle-all",
                    -- Only valid with fzf previewers (bat/cat/git/etc)
                    ["f3"]     = "toggle-preview-wrap",
                    ["f4"]     = "toggle-preview",
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                },
            }, --  }}}
            fzf_opts = {
                ['--layout'] = 'default',
            }
        }

        local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
        local imap = function(LH, RH, args) vim.keymap.set('i', LH, RH, args) end

        -- files
        -- nmap('<Leader>fr', function() fzflua.grep_project() end)
        nmap('<Leader>fr', function() fzflua.live_grep_native({ exec_empty_query = true }) end)
        nmap('<Leader>ff', function() fzflua.files() end)
        nmap('<Leader>fg', function() fzflua.git_files() end)
        nmap('<Leader>fb', function() fzflua.buffers() end)
        nmap('<Leader>fl', function() fzflua.blines() end)
        nmap('<Leader>fL', function() fzflua.lines() end)

        -- lists
        nmap('<Leader>fh', function() fzflua.help_tags() end)
        nmap('<Leader>fj', function() fzflua.jumps() end)
        nmap('<Leader>fc', function() fzflua.changes() end)
        nmap('<Leader>fm', function() fzflua.marks() end)
        nmap('<Leader>fR', function() fzflua.registers() end)
        nmap('<Leader>f:', function() fzflua.command_history() end)
        nmap('<Leader>f/', function() fzflua.search_history() end)
        nmap('<Leader>fs', function() print('hello') end)

        -- suggestions
        nmap('z=', function() fzflua.spell_suggest() end)

        -- Insert mode completion
        imap('<Leader><c-x><c-k>', function() print('hello') end)
        imap('<Leader><c-x><c-f>', function() print('hello') end)
        imap('<Leader><c-x><c-j>', function() print('hello') end)
        imap('<Leader><c-x><c-l>', function() print('hello') end)
        imap('<Leader><c-x><c-L>', function() print('hello') end)

        -- `:help vim.ui.select` for more info
        fzflua.register_ui_select()
    end,
}

-- vim: fdm=marker
