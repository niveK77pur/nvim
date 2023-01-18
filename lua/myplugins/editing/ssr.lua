return { "cshuaimin/ssr.nvim", disable=true,
    module = "ssr",
    setup = function()
        -- ts : Treesitter Search-and-replace
        vim.keymap.set({ "n", "x" }, "<Leader>ts", function() require("ssr").open() end)
    end,
    -- Calling setup is optional.
    config = function()
        require("ssr").setup {
            min_width = 50,
            min_height = 5,
            keymaps = {
                close = "q",
                next_match = "n",
                prev_match = "N",
                replace_all = "<leader><cr>",
            },
        }
    end
}
