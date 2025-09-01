return {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = true,
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        completions = {
            blink = { enabled = true },
            lsp = { enabled = true },
        },
    },
}
