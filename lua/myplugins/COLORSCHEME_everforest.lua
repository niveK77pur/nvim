return {
    'sainnhe/everforest',
    enabled = true,
    init = function()
        vim.g.everforest_enable_italic = true
        vim.g.everforest_better_performance = true
        vim.g.everforest_dim_inactive_windows = true
        -- vim.g.everforest_diagnostic_text_highlight = true
        vim.g.everforest_diagnostic_virtual_text = 'highlighted'
    end,
    config = function()
        vim.cmd.colorscheme('everforest')
    end,
}
