return { 'nvim-telescope/telescope.nvim',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'https://github.com/nvim-telescope/telescope-fzy-native.nvim' },
        -- {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
        local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end
        local tb = require('telescope.builtin')
        nmap('<leader>ff', function() tb.find_files() end)
        nmap('<leader>fr', function() tb.live_grep() end)
        nmap('<leader>fb', function() tb.buffers() end)
        nmap('<leader>fl', function() tb.current_buffer_fuzzy_find() end)
        nmap('<leader>fh', function() tb.help_tags() end)
        nmap('<leader>fj', function() tb.jumplist() end)
        nmap('<leader>fm', function() tb.marks() end)
        nmap('<leader>f:', function() tb.command_history() end)
        nmap('<leader>f/', function() tb.search_history() end)
        nmap('<leader>ft', function() tb.treesitter() end)
        -- nmap('<leader>ft', function() tb.filetypes() end)
        nmap('z=', function() tb.spell_suggest() end)

        -- require('telescope.sorters').get_fzy_sorter()
        -- https://github.com/nvim-telescope/telescope-fzy-native.nvim
        require('telescope').setup {
            extensions = {
                fzy_native = {
                    override_generic_sorter = true,
                    override_file_sorter = true,
                }
            }
        }
        require('telescope').load_extension('fzy_native')
    end,
}
