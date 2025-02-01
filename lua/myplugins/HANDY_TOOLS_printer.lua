local keymap = 'gp'
return {
    'rareitems/printer.nvim',
    enabled = true,
    keys = { keymap },
    config = function()
        require('printer').setup({
            keymap = keymap,
            -- add_to_inside = function(text)
            --     return text
            -- end,
            formatters = {
                python = function(inside, variable)
                    return string.format([[print(f'%s = {%s}')]], inside, variable)
                end,
            },
        })
    end,
}
