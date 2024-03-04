return {
    'epwalsh/obsidian.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'hrsh7th/nvim-cmp',
        'ibhagwan/fzf-lua',
    },
    lazy = true,
    cond = function()
        -- check for '.obsidian' directory in CWD
        return not (vim.fn.empty(vim.fn.glob('.obsidian')) == 1)
    end,
    ft = 'markdown',
    init = function()
        vim.opt.conceallevel = 2
    end,
    opts = {
        workspaces = {
            {
                -- The 'cond' to load the plugin will make sure that this
                -- workspace points to the root of the current vault
                name = 'current',
                path = vim.loop.cwd(),
            },
        },
        daily_notes = {
            folder = 'daily-notes',
        },
    },
}
