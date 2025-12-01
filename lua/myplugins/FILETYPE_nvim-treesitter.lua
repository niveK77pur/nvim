return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    enabled = true,
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local augroup_treesitter = vim.api.nvim_create_augroup('treesitter', {})

        vim.api.nvim_create_autocmd({ 'FileType' }, {
            group = augroup_treesitter,
            pattern = vim.tbl_keys(require('nvim-treesitter.parsers')),
            callback = function()
                require('nvim-treesitter.install').install(vim.bo.filetype)
                if vim.treesitter.language.add(vim.bo.filetype) then
                    vim.treesitter.start()
                end
            end,
        })

        vim.api.nvim_create_autocmd('FileType', {
            group = augroup_treesitter,
            pattern = 'tex',
            callback = function(args)
                require('nvim-treesitter.install').install('tex')
                if vim.treesitter.language.add('tex') then
                    vim.treesitter.start(args.buf)
                end
                vim.bo[args.buf].syntax = 'on' -- only if additional legacy syntax is needed
            end,
        })

        -- Custom parsers
        vim.api.nvim_create_autocmd('User', {
            group = augroup_treesitter,
            pattern = 'TSUpdate',
            callback = function()
                local lilypond_parser_config = { --  {{{1
                    install_info = {
                        url = 'https://github.com/nwhetsell/tree-sitter-lilypond',
                        revision = '23eb50341020381521c5bc7f6895dc50ab482b25',
                        location = 'lilypond',
                    },
                    tier = 3,
                }
                --  }}}1
                require('nvim-treesitter.parsers').lilypond =
                    vim.tbl_deep_extend('force', lilypond_parser_config, { requires = { 'lilypond-scheme' } })
                require('nvim-treesitter.parsers')['lilypond-scheme'] =
                    vim.tbl_deep_extend('force', lilypond_parser_config, {
                        install_info = {
                            location = 'lilypond-scheme',
                        },
                    })
            end,
        })
    end,
}

-- vim: fdm=marker
