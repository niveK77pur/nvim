return {
    'nvim-mini/mini.indentscope',
    enable = true,
    version = false,
    opts = function(_, opts)
        opts.draw = {
            animation = require('mini.indentscope').gen_animation.quartic(),
        }
        opts.options = {
            try_as_border = true,
        }
        -- opts.symbol = '│'
    end,
}
