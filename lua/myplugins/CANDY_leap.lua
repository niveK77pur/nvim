return {
    'ggandor/leap.nvim',
    enabled = true,
    config = function()
        require('leap').set_default_mappings()
        vim.schedule(function()
            vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Conceal' })
        end)
    end,
}
