local cmd_name_disable = 'ConformDisable'
local cmd_name_enable = 'ConformEnable'
return {
    'stevearc/conform.nvim',
    enabled = true,
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo', cmd_name_disable, cmd_name_enable },
    keys = {
        {
            -- Customize or remove this keymap to your liking
            '<leader>lf',
            function()
                require('conform').format({ async = true, lsp_fallback = true })
            end,
            desc = 'Format buffer',
        },
    },
    config = function()
        local column_width = tonumber(vim.wo.colorcolumn) or 80
        vim.g.disable_autoformat = false -- enable auto formatting by default
        require('conform').setup({
            -- Define your formatters
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'isort', { 'ruff_format', 'blue', 'black' } },
                tex = { 'latexindent' },
                rust = { 'rustfmt' },
                lilypond = { 'ly' },
                go = { { 'golines', 'goimports', 'gofmt' } },
                sh = { { 'shfmt' } },
                java = { 'google-java-format' },
                nix = { { 'alejandra', 'nixpkgs-fmt' } },
            },
            format_on_save = function(bufnr) --  {{{
                -- Disable with a global or buffer-local variable
                if
                    vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat
                then
                    return
                end
                return { timeout_ms = 500, lsp_fallback = true }
            end, --  }}}
            formatters = {
                shfmt = { --  {{{
                    prepend_args = { '-i', 4, '-s' },
                }, --  }}}
                stylua = { --  {{{
                    prepend_args = {
                        '--column-width',
                        column_width,
                        '--indent-type',
                        'Spaces',
                        '--quote-style',
                        'AutoPreferSingle',
                    },
                }, --  }}}
                rustfmt = { --  {{{
                    prepend_args = {
                        '--edition',
                        '2021',
                        '--config',
                        'format_code_in_doc_comments=true'
                            .. ','
                            .. 'wrap_comments=true',
                        -- .. ','
                        -- .. 'max_width='
                        -- .. column_width
                        -- .. ','
                        -- .. 'comment_width='
                        -- .. column_width,
                    },
                }, --  }}}
                ly = { --  {{{
                    command = 'ly',
                    args = { 'reformat' },
                }, --  }}}
                ruff_format = {
                    -- prepend_args does no work here. See https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/ruff_format.lua
                    args = {
                        'format',
                        '--config',
                        'format.quote-style = "single"',
                        '--config',
                        string.format('line-length = %s', column_width),
                        '--force-exclude',
                        '--stdin-filename',
                        '$FILENAME',
                        '-',
                    },
                },
            },
        })
        -- Command to toggle format-on-save {{{
        -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
        vim.api.nvim_create_user_command(cmd_name_disable, function(args)
            if args.bang then
                -- ConformDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = 'Disable autoformat-on-save',
            bang = true,
        })
        vim.api.nvim_create_user_command(cmd_name_enable, function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = 'Re-enable autoformat-on-save',
        })
        --  }}}
    end,
    -- init = function()
    --     -- If you want the formatexpr, here is the place to set it
    --     vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    -- end,
}

-- vim: fdm=marker
