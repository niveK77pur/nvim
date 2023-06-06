return { 'rareitems/printer.nvim',
    enabled = true,
    config = function()
        require('printer').setup({
            keymap = "gp",
            -- add_to_inside = function(text)
            --     return text
            -- end,
            formatters = {
                python = function(inside, variable)
                    return string.format([[print(f'%s = {%s}')]], inside, variable)
                end
            },
        })
    end
}
