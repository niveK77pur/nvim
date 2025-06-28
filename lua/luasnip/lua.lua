return {
    s(
        { trig = '([nvxsoilct]*)map', trigEngine = 'pattern' },
        fmta(
            [[
            vim.keymap.set(<mode>, '<lhs>', <rhs>, {
                desc = '<desc>',
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
                desc = i(1, 'My Super Cool Mapping'),
                lhs = i(2, '<lhs>'),
                rhs = i(0, "'<rhs>'"),
            }
        )
    ),
    s(
        { trig = 'luasnip', desc = 'Snippet template for LuaSnip' },
        fmta(
            [=[
            s(
                { trig = '<trig>', desc = '<desc>' },
                <fmt>(
                    [[
                    <snip>
                    ]],
                    {
                        <keys>
                    }
                )
            )
            ]=],
            {
                trig = i(1),
                desc = i(2),
                fmt = c(3, { t('fmt'), t('fmta') }),
                snip = i(4),
                keys = i(5),
            }
        )
    ),
}
