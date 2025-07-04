return {
    'echasnovski/mini.pairs',
    enable = true,
    version = false,
    event = 'VeryLazy',
    config = function()
        local ft, _ = vim.filetype.match({ buf = vim.api.nvim_get_current_buf() })

        if ft == 'lilypond' then
            -- Set which LilyPond characters should not be auto-paired.
            require('mini.pairs').setup({
                mappings = {
                    ['('] = false,
                    [')'] = false,
                    ['['] = false,
                    [']'] = false,
                    ["'"] = false,
                },
            })
        else
            require('mini.pairs').setup()
        end
    end,
}
