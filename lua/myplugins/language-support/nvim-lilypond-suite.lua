return { 'martineausimon/nvim-lilypond-suite',
    requires = {
        'MunifTanjim/nui.nvim',
        { 'uga-rosa/cmp-dictionary', requires = 'hrsh7th/nvim-cmp' },
    },
    ft = { 'lilypond' },
    config = function()
        require('nvls').setup{
            lilypond = {
                mappings = {
                    player = "<F3>",
                    compile = "<F5>",
                    open_pdf = "<F6>",
                    switch_buffers = "<F2>",
                    insert_version = "<F4>"
                },
                options = {
                    pitches_language = "default",
                    output = "pdf",
                    -- main_file = "main.ly"
                },
            },
        }

        vim.api.nvim_create_autocmd( 'QuickFixCmdPost', {
            command = "cwindow",
            pattern = "*"
        })
        vim.api.nvim_create_autocmd('BufEnter', { 
            command = "syntax sync fromstart",
            pattern = { '*.ly', '*.ily', '*.tex' }
        })

        local LILYDICTPATH = packer_plugins['nvim-lilypond-suite'].path .. '/lilywords'
        require('cmp_dictionary').setup{
            dic = { --  {{{
                ["lilypond"] = {
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
                }
            } --  }}}
        }
    end
}

-- vim: fdm=marker
