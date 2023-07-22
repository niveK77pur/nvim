return {
    "ibhagwan/fzf-lua",
    dependencies = {
        -- 'nvim-tree/nvim-web-devicons',
        { "junegunn/fzf", build = "./install --xdg --all --no-fish" },
    },
    enabled = true,
    config = function()
        local fzflua = require("fzf-lua")
        fzflua.setup({
            keymap = {
                --  {{{
                builtin = {
                    -- neovim `:tmap` mappings for the fzf win
                    ["<F1>"] = "toggle-help",
                    ["<F2>"] = "toggle-fullscreen",
                    -- Only valid with the 'builtin' previewer
                    ["<F3>"] = "toggle-preview-wrap",
                    ["<F4>"] = "toggle-preview",
                    -- Rotate preview clockwise/counter-clockwise
                    ["<F5>"] = "toggle-preview-ccw",
                    ["<F6>"] = "toggle-preview-cw",
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
                    ["alt-a"] = "toggle-all",
                    -- Only valid with fzf previewers (bat/cat/git/etc)
                    ["f3"] = "toggle-preview-wrap",
                    ["f4"] = "toggle-preview",
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                },
            }, --  }}}
            fzf_opts = {
                ["--layout"] = "default",
            },
        })

        local nmap = function(LH, RH, args)
            vim.keymap.set("n", LH, RH, args)
        end
        local imap = function(LH, RH, args)
            vim.keymap.set("i", LH, RH, args)
        end

        -- files
        -- nmap('<Leader>fr', function() fzflua.grep_project() end)
        nmap("<Leader>fr", function()
            fzflua.live_grep_native({ exec_empty_query = true })
        end, { desc = "FZF: Live grep" })
        nmap("<Leader>ff", function()
            fzflua.files()
        end, { desc = "FZF: Navigate files" })
        nmap("<Leader>fg", function()
            fzflua.git_files()
        end, { desc = "FZF: Navigate git files" })
        nmap("<Leader>fb", function()
            fzflua.buffers()
        end, { desc = "FZF: Navigate buffers" })
        nmap("<Leader>fl", function()
            fzflua.blines()
        end, { desc = "FZF: Navigate lines in buffer" })
        nmap("<Leader>fL", function()
            fzflua.lines()
        end, { desc = "FZF: Navigate lines in all open buffers" })

        -- lists
        nmap("<Leader>fh", function()
            fzflua.help_tags()
        end, { desc = "FZF: Help tags" })
        nmap("<Leader>fj", function()
            fzflua.jumps()
        end, { desc = "FZF: :jumps" })
        nmap("<Leader>fc", function()
            fzflua.changes()
        end, { desc = "FZF: :changes" })
        nmap("<Leader>fm", function()
            fzflua.marks()
        end, { desc = "FZF: marks" })
        nmap("<Leader>fR", function()
            fzflua.registers()
        end, { desc = "FZF: registers" })
        nmap("<Leader>f:", function()
            fzflua.command_history()
        end, { desc = "FZF: command history" })
        nmap("<Leader>f/", function()
            fzflua.search_history()
        end, { desc = "FZF: serach history" })

        -- suggestions
        nmap("z=", function()
            fzflua.spell_suggest()
        end, { desc = "FZF: spell suggestions" })

        -- Insert mode completion (also check junegunn/fzf.vim config)
        imap("<Leader><c-x><c-f>", function()
            fzflua.complete_path()
        end, { desc = "FZF: Complete path" })
        imap("<Leader><c-x><c-l>", function()
            fzflua.complete_line()
        end, { desc = "FZF: Complete line" })
        imap("<Leader><c-x><c-L>", function()
            fzflua.complete_bline()
        end, { desc = "FZF: Complete line (buffer local)" })

        -- Mapping selecting mappings
        vim.keymap.set({ "n", "i", "c" }, "<Leader><tab>", function()
            fzflua.keymaps()
        end, { desc = "FZF: Select mappings" })

        -- `:help vim.ui.select` for more info
        fzflua.register_ui_select()
    end,
}

-- vim: fdm=marker
