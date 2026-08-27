return {
    s(
        [[\newac]],
        fmt([[\newacronym{<id>}{<short>}{<long>}]], {
            id = d(3, function(args)
                local short = args[1][1]
                local short = string.lower(short)
                return sn(nil, { i(1, short) })
            end, { 2 }),
            short = d(2, function(args)
                local long = args[1][1]
                local id = string.sub(long, 1, 1)
                for letter in string.gmatch(long, '%s(%w)') do
                    id = id .. letter
                end
                return sn(nil, { i(1, string.upper(id)) })
            end, { 1 }),
            long = i(1),
        }, { delimiters = '<>' })
    ),
}
