return {
    'epwalsh/obsidian.nvim',
    enabled = true,
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
    keys = {
        { '<LocalLeader>oq', '<Cmd>ObsidianQuickSwitch<CR>' },
        { '<LocalLeader>oo', '<Cmd>ObsidianOpen<CR>' },
        { '<LocalLeader>ot', '<Cmd>ObsidianToday<CR>' },
        { '<LocalLeader>oT', '<Cmd>ObsidianTomorrow<CR>' },
        { '<LocalLeader>os', '<Cmd>ObsidianSearch<CR>' },
    },
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
