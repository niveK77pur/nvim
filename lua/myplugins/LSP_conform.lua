return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
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
        require('conform').setup({
            -- Define your formatters
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'isort', 'blue' },
                latex = { 'latexindent' },
                rust = { 'rustfmt' },
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
                    prepend_args = { '-i', '2' },
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
                    '--config',
                    'max_width='
                        .. column_width
                        .. ','
                        .. 'comment_width='
                        .. column_width
                        .. ','
                        .. 'wrap_comments=true'
                        .. ','
                        .. 'format_code_in_doc_comments=true',
                }, --  }}}
            },
        })
        -- Command to toggle format-on-save {{{
        -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
        vim.api.nvim_create_user_command('FormatDisable', function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = 'Disable autoformat-on-save',
            bang = true,
        })
        vim.api.nvim_create_user_command('FormatEnable', function()
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