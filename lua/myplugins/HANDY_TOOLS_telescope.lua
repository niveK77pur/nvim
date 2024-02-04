return {
    'nvim-telescope/telescope.nvim',
    enabled = false,
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'https://github.com/nvim-telescope/telescope-fzy-native.nvim' },
        -- {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
        local nmap = function(LH, RH, args)
            vim.keymap.set('n', LH, RH, args)
        end
        local tb = require('telescope.builtin')

        -- Files ---------------------------------------------------------------
        nmap('<leader>fr', tb.live_grep, { desc = 'Telescope: Live grep' })
        nmap('<leader>ff', function()
            tb.find_files({ no_ignore = true })
        end, { desc = 'Telescope: Navigate files' })
        nmap(
            '<leader>fg',
            tb.find_files,
            { desc = 'Telescope: Navigate git files' }
        )
        nmap('<leader>fb', tb.buffers, { desc = 'Telescope: Navigate buffers' })
        nmap(
            '<leader>fl',
            tb.current_buffer_fuzzy_find,
            { desc = 'Telescope: Navigate lines in buffer' }
        )
        nmap('<leader>fL', function()
            tb.live_grep({ grep_open_files = true })
        end, {
            desc = 'Telescope: Navigate lines in all open buffer',
        })

        -- Lists ---------------------------------------------------------------
        nmap('<leader>fh', tb.help_tags, { desc = 'Telescope: Help tags' })
        nmap('<leader>fj', tb.jumplist, { desc = 'Telescope: :jumps' })
        nmap('<leader>fc', function()
            vim.notify('Telescope cannot list :changes', vim.log.levels.ERROR)
        end, { desc = 'Telescope: `:changes`' })
        nmap('<leader>fm', tb.marks, { desc = 'Telescope: marks' })
        nmap('<leader>fR', tb.registers, { desc = 'Telescope: registers' })
        nmap(
            '<leader>f:',
            tb.command_history,
            { desc = 'Telescope: command history' }
        )
        nmap(
            '<leader>f/',
            tb.search_history,
            { desc = 'Telescope: serach history' }
        )
        nmap('<leader>ft', function()
            vim.notify(
                'Telescope cannot list filter for TODOs',
                vim.log.levels.ERROR
            )
        end, { desc = 'Telescope: search TODOs (TODO)' })
        nmap(
            '<leader>fT',
            tb.treesitter,
            { desc = 'Telescope: treesitter picker' }
        )
        -- nmap('<leader>ft', function() tb.filetypes() end)

        -- Suggestions ---------------------------------------------------------
        nmap('z=', tb.spell_suggest, { desc = 'Telescope: spell suggestions' })

        -- Insert mode completion ----------------------------------------------
        -- TODO

        -- Mapping selecting mappings ------------------------------------------

        -- vim.ui.select -------------------------------------------------------

        -- require('telescope.sorters').get_fzy_sorter()
        -- https://github.com/nvim-telescope/telescope-fzy-native.nvim
        local actions = require('telescope.actions')
        require('telescope').setup({
            defaults = {
                layout_strategy = 'flex',
                mappings = {
                    i = {
                        ['<C-u>'] = actions.results_scrolling_up,
                        ['<C-d>'] = actions.results_scrolling_down,
                        ['<C-b>'] = actions.preview_scrolling_up,
                        ['<C-f>'] = actions.preview_scrolling_down,
                    },
                },
            },
            extensions = {
                fzy_native = {
                    override_generic_sorter = true,
                    override_file_sorter = true,
                },
            },
        })
        require('telescope').load_extension('fzy_native')
    end,
}
