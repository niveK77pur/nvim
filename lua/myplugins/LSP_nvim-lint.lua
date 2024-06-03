local linters = {
    sh = { 'shellcheck' },
    lilypond = { 'lilypond' },
}

local function lilypond_parser(openlilylib_path) --  {{{
    local pattern = '^-:(%d+):(%d+): (%w+): (.*)'
    local groups = { 'lnum', 'col', 'severity', 'message' }
    local severity_map = {
        ['error'] = vim.diagnostic.severity.ERROR,
        ['warning'] = vim.diagnostic.severity.WARN,
    }

    return {
        cmd = 'lilypond',
        stdin = true,
        args = {
            string.format('--include=%s', openlilylib_path),
            '--output=/dev/null',
            '-dbackend=null',
            '-dno-print-pages',
            '-dcompile-scheme-code',
            '-dno-aux-files',
            '-dno-include-eps-fonts',
            '-dno-include-book-title-preview',
            '-dno-point-and-click',
            '-',
        },
        stream = 'stderr',
        ignore_exitcode = true,
        parser = require('lint.parser').from_pattern(
            pattern,
            groups,
            severity_map,
            {
                severity = vim.diagnostic.severity.INFO,
            }
        ),
    }
end --  }}}

return {
    'mfussenegger/nvim-lint',
    enabled = true,
    ft = vim.tbl_keys(linters),
    config = function()
        local lint = require('lint')

        lint.linters.lilypond = lilypond_parser('./openlilylib')

        lint.linters_by_ft = linters
        vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}

-- vim: fdm=marker
