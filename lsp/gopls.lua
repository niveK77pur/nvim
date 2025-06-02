return {
    settings = {
        gopls = {
            hints = {
                -- See https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
}
