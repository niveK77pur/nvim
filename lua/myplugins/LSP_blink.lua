return {
    'saghen/blink.cmp',
    enabled = function()
        -- only enable when nvim-cmp is not enabled
        return require('lazy.core.config').plugins['nvim-cmp'] == nil
    end,
    dependencies = {
        'rafamadriz/friendly-snippets',
        'MahanRahmati/blink-nerdfont.nvim',
        'Kaiser-Yang/blink-cmp-dictionary',
        'erooke/blink-cmp-latex',
    },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'default',
        },

        signature = {
            enabled = true,
        },

        completion = {
            keyword = {
                range = 'full',
            },
        },

        sources = {
            default = {
                'lazydev',
                'lsp',
                'omni',
                'snippets',
                'nerdfont',
                'latex',
                'path',
                'buffer',
            },
            per_filetype = {
                lilypond = { 'lsp', 'snippets', 'lilypond_dict' },
            },
            providers = {
                lazydev = { -- {{{1
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
                nerdfont = { -- {{{1
                    module = 'blink-nerdfont',
                    name = 'Nerd Fonts',
                    score_offset = 15, -- Tune by preference
                    opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
                },
                lilypond_dict = { -- {{{1
                    module = 'blink-cmp-dictionary',
                    name = 'nvim-lilpond-suite dictionary',
                    min_keyword_length = 3,
                    max_items = 8,
                    opts = {
                        dictionary_files = function()
                            local nls_lazy = require('lazy.core.config').plugins['nvim-lilypond-suite']
                            if nls_lazy == nil then
                                vim.notify(
                                    'Could not set up nvim-lilpond-suite dictionary completion source. Plugin does not seem to be loaded.',
                                    vim.log.levels.ERROR
                                )
                                return
                            end
                            local LILYDICTPATH = nls_lazy.dir .. '/lilywords'
                            return vim.fn.glob(LILYDICTPATH .. '/*', true, true)
                        end,
                    },
                },
                latex = { -- {{{1
                    name = 'Latex',
                    module = 'blink-cmp-latex',
                    opts = {
                        insert_command = function(ctx)
                            local ft = vim.api.nvim_get_option_value('filetype', {
                                scope = 'local',
                                buf = ctx.bufnr,
                            })
                            if ft == 'tex' then
                                return true
                            end
                            return false
                        end,
                    },
                },
                -- }}}1
            },
        },
    },
    opts_extend = { 'sources.default' },
}

-- vim: fdm=marker
