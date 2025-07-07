local shape_displacement_node = function(pos) --  {{{1
    return sn(pos, {
        -- `({ax} . {ay}) ({bx} . {by}) ({cx} . {cy}) ({dx} . {dy})`
        t('('),
        i(1, '0'),
        t(' . '),
        i(2, '0'),
        t(') ('),
        i(3, '0'),
        t(' . '),
        i(4, '0'),
        t(') ('),
        i(5, '0'),
        t(' . '),
        i(6, '0'),
        t(') ('),
        i(7, '0'),
        t(' . '),
        i(8, '0'),
        t(')'),
    })
end
--  }}}1

return {
    s(
        --  {{{
        { trig = 'pt', desc = 'Polyphonic passage' },
        fmt(
            [[
            << {{ \voiceOne
                {voiceOne}
              }}
              \new Voice {{ \voiceTwo
                {voiceTwo}
              }}
            >> \oneVoice
            ]],
            {
                voiceOne = c(1, {
                    f(function(_, snip, _)
                        return snip.env.LS_SELECT_RAW
                    end),
                    i(1),
                }),
                voiceTwo = i(2),
            }
        )
        --  }}}
    ),
    s({ trig = '1v', desc = [[\oneVoice]] }, t([[\oneVoice]])),
    s(
        --  {{{
        { trig = 'v([1234])', trigEngine = 'pattern', desc = 'Multiple Voices' },
        fmt([[\voice{number}]], {
            number = f(function(_, snippet, _)
                local num = tonumber(snippet.captures[1])
                if num == nil then
                    return '?'
                elseif num == 1 then
                    return 'One'
                elseif num == 2 then
                    return 'Two'
                elseif num == 3 then
                    return 'Three'
                elseif num == 4 then
                    return 'Four'
                end
            end),
        })
        --  }}}
    ),
    s(
        --  {{{
        { trig = 'ch', trigEngine = 'pattern', desc = 'change staff' },
        fmt([[\change Staff = "{staff}"]], {
            staff = c(1, {
                t('left'),
                t('right'),
                i(1),
            }),
        })
        --  }}}
    ),
    s(
        --  {{{
        { trig = [[o(-?%d)]], trigEngine = 'pattern', desc = [[\ottava x]] },
        fmt([[\ottava {value}]], {
            value = f(function(_, snippet, _)
                return tostring(snippet.captures[1])
            end),
        })
        --  }}}
    ),
    s(
        --  {{{
        { trig = '(v?)shape', trigEngine = 'pattern', desc = [[\vshape or \shape]] },
        fmt([[\{v}shape #'({displacements}) {item}]], {
            v = f(function(_, snippet, _)
                return snippet.captures[1] or ''
            end),
            item = c(1, {
                t('PhrasingSlur'),
                t('Slur'),
                t('Tie'),
                t('RepeatTie'),
                t('LaissezVibrerTie'),
            }),
            displacements = c(2, {
                shape_displacement_node(1),
                sn(1, {
                    t('('),
                    shape_displacement_node(1),
                    t(') ('),
                    shape_displacement_node(2),
                    t(')'),
                }),
            }),
        })
        --  }}}
    ),
    s(
        --  {{{
        { trig = 't', desc = [[\tuplet]] },
        fmta([[\tuplet <fraction> { <music> }]], {
            fraction = i(1, '3/2'),
            music = c(2, {
                f(function(_, snip, _)
                    return snip.env.LS_SELECT_RAW
                end),
                i(1),
            }),
        })
        --  }}}
    ),
    s(
        --  {{{
        { trig = [[\vc([tb])([_^]\d+)?]], trigEngine = 'vim', desc = [[\clef "treble_8"]] },
        fmt([[\clef "{clef}{alteration}"]], {
            clef = f(function(_, snip, _)
                local clef = snip.captures[1]
                if clef == 't' then
                    return 'treble'
                elseif clef == 'b' then
                    return 'bass'
                end
                return '?'
            end),
            alteration = f(function(_, snip, _)
                return snip.captures[2] or ''
            end),
        })
        --  }}}
    ),
    s(
        --  {{{
        { trig = 'repeat', desc = [[\repeat]] },
        fmta([[\repeat <type> <count> { <music> }]], {
            type = c(1, {
                t('unfold'),
                t('tremolo'),
                t('volta'),
                t('segno'),
                t('percent'),
            }),
            count = i(2, '4'),
            music = c(3, {
                f(function(_, snip, _)
                    return snip.env.LS_SELECT_RAW
                end),
                i(1),
            }),
        })
        --  }}}
    ),
    s(
        --  {{{
        { trig = 'em', desc = [[\editionMod]] },
        fmt([[\editionMod {edition} {measure} {moment}/{division} music.{context}{voice} {edit}]], {
            edition = c(1, {
                t('tweaks'),
                t('dynamics'),
                t('fingering'),
                i(1, 'other'),
            }, { key = 'edition' }),
            measure = i(2, 'measure'),
            moment = i(3, 'moment'),
            division = i(4, '4'),
            context = d(5, function(args)
                local edition_text = args[1][1]
                local n = {
                    v = t('Voice'),
                    d = t('Dynamics'),
                    o = i(1, 'Other'),
                }
                if edition_text == 'dynamics' then
                    return sn(nil, { c(1, { n.d, n.v, n.o }) })
                end
                return sn(nil, { c(1, { n.v, n.d, n.o }) })
            end, { k('edition') }, { key = 'context' }),
            voice = d(6, function(args)
                local context_text = args[1][1]
                if context_text == 'Dynamics' then
                    return sn(nil, { t('') })
                end
                return sn(nil, { t('.'), i(1, 'A') })
            end, { k('context') }),
            edit = i(7, '-"Editions"'),
        })
        --  }}}
    ),
}

-- vim: fdm=marker
