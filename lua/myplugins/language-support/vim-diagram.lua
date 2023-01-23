return { 'zhaozg/vim-diagram',
    cond = function()
        local ext = vim.fn.expand('%:e')
        return ext == 'mmd' or ext == 'seq' or ext == 'sequence'
    end,
    setup = function()
        local augroup_mermaid = vim.api.nvim_create_augroup('mermaid', {})
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            group = augroup_mermaid,
            pattern = { '*.mmd' },
            desc = "Also recognize mmd extension for mermaid",
            callback = function()
                vim.bo.filetype = 'sequence'
            end,
        })
    end,
}
