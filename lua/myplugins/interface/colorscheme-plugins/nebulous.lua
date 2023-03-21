return { 'Yagua/nebulous.nvim',
    enabled = false,
    config = function()
        local variant = ({ 'night', 'twilight', 'midnight', 'fullmoon', 'nova', 'quasar', })[3]
        local colors = require("nebulous.functions").get_colors(variant) -- < variant name
        require("nebulous").setup {
            variant = variant,
            disable = {
                background = false,
                endOfBuffer = false,
                terminal_colors = false,
            },
            italic = {
                comments   = true,
                keywords   = false,
                functions  = false,
                variables  = false,
            },
            custom_colors = {
                -- Normal = { fg = colors.none, bg = colors.Black, style = colors.none },
                -- TSVariable = { fg = colors.none },

                PMenuSel = { fg = colors.White, bg = colors.Grey },
                Conceal  = { fg = colors.DarkBlue },

                -- disable italic by default:
                Special = { style = "NONE" },
                String  = { style = "NONE" },

            }
        }
    end
}
