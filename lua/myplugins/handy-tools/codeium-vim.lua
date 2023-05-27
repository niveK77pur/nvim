return {
    "Exafunction/codeium.vim",
    enabled = false,
    setup = function()
        vim.g.codeium_disable_bindings = 1
    end,
    config = function()
        vim.keymap.set("i", "<tab>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true, desc = "Accept codeium suggestion" })
        vim.keymap.set("i", "<a-,>", function()
            return vim.fn["codeium#CycleCompletions"](-1)
        end, { expr = true, desc = "Previous codeium suggestion" })
        vim.keymap.set("i", "<a-.>", function()
            return vim.fn["codeium#CycleCompletions"](1)
        end, { expr = true, desc = "NexNex suggestion" })
        vim.keymap.set("i", "<c-Bslash>", function()
            return vim.fn["codeium#Clear"]()
        end, { expr = true, desc = "Clear codeium suggestion" })
    end,
}
