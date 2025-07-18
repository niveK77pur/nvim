return {
    'martineausimon/nvim-lilypond-suite',
    dependencies = {
        'MunifTanjim/nui.nvim',
        {
            'uga-rosa/cmp-dictionary',
            dependencies = { 'hrsh7th/nvim-cmp' },
            enabled = require('lazy.core.config').plugins['nvim-cmp'] ~= nil,
        },
    },
    enabled = true,
    ft = { 'lilypond' },
    config = function()
        require('nvls').setup({
            lilypond = {
                mappings = {
                    player = '<F3>',
                    compile = '<F5>',
                    open_pdf = '<F6>',
                    switch_buffers = '<F2>',
                    insert_version = '<F4>',
                },
                options = {
                    pitches_language = 'default',
                    output = 'pdf',
                    -- main_file = "main.ly"
                    include_dir = {
                        './openlilylib',
                    },
                },
            },
        })

        vim.api.nvim_create_autocmd({ 'DiagnosticChanged' }, {
            desc = 'Notify when there are diagnostics',
            callback = function(args)
                vim.notify(
                    ('There are %d diagnostics in %s'):format(
                        vim.tbl_count(args.data.diagnostics),
                        vim.fs.basename(args.file)
                    ),
                    vim.log.levels.WARN,
                    { group = 'lilypond', annote = 'NVLS' }
                )
            end,
        })
        vim.api.nvim_create_autocmd('BufEnter', {
            command = 'syntax sync fromstart',
            pattern = { '*.ly', '*.ily', '*.tex' },
        })

        if require('lazy.core.config').plugins['nvim-cmp'] ~= nil then
            local LILYDICTPATH = require('lazy.core.config').plugins['nvim-lilypond-suite'].dir .. '/lilywords'
            require('cmp_dictionary').setup({
                dic = { --  {{{
                    ['lilypond'] = {
                        LILYDICTPATH .. '/accidentalsStyles',
                        LILYDICTPATH .. '/articulations',
                        LILYDICTPATH .. '/clefs',
                        LILYDICTPATH .. '/contextProperties',
                        LILYDICTPATH .. '/contexts',
                        LILYDICTPATH .. '/contextsCmd',
                        LILYDICTPATH .. '/dynamics',
                        LILYDICTPATH .. '/grobProperties',
                        LILYDICTPATH .. '/grobs',
                        LILYDICTPATH .. '/headerVariables',
                        LILYDICTPATH .. '/keywords',
                        LILYDICTPATH .. '/languageNames',
                        LILYDICTPATH .. '/markupCommands',
                        LILYDICTPATH .. '/musicCommands',
                        LILYDICTPATH .. '/musicFunctions',
                        LILYDICTPATH .. '/paperVariables',
                        LILYDICTPATH .. '/repeatTypes',
                        LILYDICTPATH .. '/scales',
                        LILYDICTPATH .. '/translators',
                    },
                }, --  }}}
            })
        end
    end,
}

-- vim: fdm=marker
