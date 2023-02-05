return {
    'ckolkey/ts-node-action',
    requires = { 'nvim-treesitter' },
    config = function()
        require("ts-node-action").setup({})
        vim.keymap.set(
            { "n" },
            "<Leader>ta",
            require("ts-node-action").node_action,
            { desc = "Trigger Node Action" }
        )
    end
}
