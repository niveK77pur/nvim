return {
    s(
        { trig = '([nvxsoilct]*)map', trigEngine = 'pattern' },
        fmta(
            [[
            vim.keymap.set(<mode>, '<lhs>', <rhs>, {
                desc = '<desc>',
                <noremap>
            })
            ]],
            {
                mode = f(function(_, snippet, _)
                    local modes = vim.tbl_map(function(letter)
                        return string.format("'%s'", vim.fn.list2str({ letter }))
                    end, vim.fn.str2list(snippet.captures[1]))
                    if #modes == 0 then
                        return "''"
                    elseif #modes == 1 then
                        return modes[1]
                    elseif #modes > 1 then
                        return string.format('{%s}', vim.fn.join(modes, ','))
                    else
                        return 'ERROR'
                    end
                end),
                lhs = i(1, '<lhs>'),
                desc = i(2, 'My Super Cool Mapping'),
                noremap = c(3, {
                    t('noremap = true,'),
                    t(''),
                }),
                rhs = i(0, "'<rhs>'"),
            }
        )
    ),
}
