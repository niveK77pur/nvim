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
                vim.treesitter.start()
            end,
        })

        vim.api.nvim_create_autocmd('FileType', {
            group = augroup_treesitter,
            pattern = 'tex',
            callback = function(args)
                vim.treesitter.start(args.buf)
                vim.bo[args.buf].syntax = 'on' -- only if additional legacy syntax is needed
            end,
        })

        -- Custom parsers
        vim.api.nvim_create_autocmd('User', {
            group = augroup_treesitter,
            pattern = 'TSUpdate',
            callback = function()
                local lilypond_install_info = { --  {{{1
                    url = 'https://github.com/nwhetsell/tree-sitter-lilypond',
                    revision = '23eb50341020381521c5bc7f6895dc50ab482b25',
                    location = 'lilypond',
                    queries = 'queries',
                }
                require('nvim-treesitter.parsers').lilypond = { --  {{{1
                    install_info = lilypond_install_info,
                    tier = 3,
                }
                require('nvim-treesitter.parsers')['lilypond-scheme'] = { --  {{{1
                    install_info = vim.tbl_extend('force', lilypond_install_info, { location = 'lilypond-scheme' }),
                    tier = 3,
                }
                --  }}}1
            end,
        })
    end,
}

-- vim: fdm=marker
