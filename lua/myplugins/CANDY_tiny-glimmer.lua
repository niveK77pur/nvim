return {
    'rachartier/tiny-glimmer.nvim',
    enabled = true,
    event = 'VeryLazy',
    priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings.
    opts = {
        overwrite = {
            undo = {
                enabled = true,
            },
            redo = {
                enabled = true,
            },
        },
    },
}
