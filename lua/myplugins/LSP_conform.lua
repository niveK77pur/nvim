local cmd_name_disable = 'ConformDisable'
local cmd_name_enable = 'ConformEnable'
local function pick_formatters(...)
    local formatters = {}
    for _, f in ipairs({ ... }) do
        if type(f) == 'string' then
            table.insert(formatters, f)
        elseif type(f) == 'table' then
            for _, formatter in ipairs(f) do
                if require('conform').get_formatter_info(formatter).available then
                    table.insert(formatters, formatter)
                    break
                end
            end
        else
            vim.notify(
                string.format('Invalid type for formatter picking: %s (%s)', f, type(f)),
                vim.log.levels.ERROR,
                { group = 'conform.nvim', title = 'conform.nvim' }
            )
        end
    end
    return formatters
end

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
        local formatters_by_ft = {
            c = { 'clang-format' },
            fish = { 'fish_indent' },
            go = pick_formatters({ 'golines', 'goimports', 'gofmt' }),
            java = { 'google-java-format' },
            json = pick_formatters('fixjson', { 'yq', 'jq' }),
            kotlin = { 'ktfmt' },
            lilypond = { 'ly' },
            lua = { 'stylua' },
            nix = pick_formatters({ 'nixfmt', 'alejandra' }),
            python = pick_formatters('isort', { 'ruff_format', 'blue', 'black' }),
            rust = { 'rustfmt' },
            sh = { 'shfmt' },
            tex = { 'latexindent' },
            typescript = { 'prettierd' },
            xml = { 'xmlformatter' },
        }

        formatters_by_ft.typescriptreact = formatters_by_ft.typescript
        formatters_by_ft.javascript = formatters_by_ft.typescript
        formatters_by_ft.javascriptreact = formatters_by_ft.typescript
        formatters_by_ft.html = formatters_by_ft.typescript
        formatters_by_ft.cpp = formatters_by_ft.c

        vim.g.disable_autoformat = false -- enable auto formatting by default
        require('conform').setup({
            -- Define your formatters
            formatters_by_ft = formatters_by_ft,
            format_on_save = function(bufnr) --  {{{
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 500, lsp_fallback = true }
            end, --  }}}
            formatters = {
                shfmt = { --  {{{
                    prepend_args = { '-i', 4, '-s' },
                }, --  }}}
                ly = { --  {{{
                    command = 'ly',
                    args = { 'reformat' },
                }, --  }}}
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
