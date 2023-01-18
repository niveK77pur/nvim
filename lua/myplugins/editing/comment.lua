-- return { 'scrooloose/nerdcommenter', disable = true }

return { 'numToStr/Comment.nvim', disable = false, -- {{{
    config = function()
        require('Comment').setup {
            -- Enable keybindings
            -- NOTE: If given `false` then the plugin won't create any mappings
            mappings = {
                -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
                basic = true,
                -- Extra mapping; `gco`, `gcO`, `gcA`
                extra = true,
                -- Extended mapping; `g>` `g<` `g>[count]{motion}` `g<[count]{motion}`
                extended = false,
            },
            -- Changing mappings to use <Leader>c (like NERDCommenter)
            -- makes operator-pending mappings not work
        }
    end,
} -- }}}
