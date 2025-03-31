return {
    'oskarrrrrrr/symbols.nvim',
    enabled = true,
    config = function()
        local r = require('symbols.recipes')
        require('symbols').setup(r.DefaultFilters, r.AsciiSymbols, {
            sidebar = {
                open_direction = 'right',
                ---@diagnostic disable-next-line: unused-local
                symbol_filter = function(filetype, symbol)
                    return true
                end,
                preview = {
                    keymaps = {
                        ['q'] = 'close',
                        ['<CR>'] = 'goto-code',
                    },
                },
                show_inline_details = true,
            },
        })

        vim.keymap.set('n', '<Leader>ls', '<cmd>SymbolsToggle<CR>')
    end,
}
