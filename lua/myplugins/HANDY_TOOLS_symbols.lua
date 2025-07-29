return {
    'oskarrrrrrr/symbols.nvim',
    enabled = true,
    keys = {
        { '<Leader>ls', '<cmd>SymbolsToggle<CR>', desc = 'symbols.nvim: Toggle' },
    },
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
    end,
}
