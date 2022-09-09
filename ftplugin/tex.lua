--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Settings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.bo.tabstop       = 2
vim.bo.textwidth     = 70
-- vim.bo.noexpandtab
--
-- vim.bo.keywordprg='texdoc'
vim.g.vimtex_doc_handlers = { 'vimtex#doc#handlers#texdoc' }

vim.wo.spell         = true
-- allow concealing with vimtex
vim.wo.conceallevel  = 2
vim.wo.concealcursor = 'n'
vim.bo.smartindent   = false
-- vim.wo.foldenable    = false

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                 AutoCommands
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local augroup_latexft = vim.api.nvim_create_augroup('latexft', {})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = augroup_latexft,
    pattern = { '*.cls' },
    desc = [[Update modified date in \ProvidesClass command]],
    callback = function()
        local v = vim.fn.winsaveview()
        vim.cmd [[g/^\\ProvidesClass/s#\v\[\s*\zs[^] ]*#\=strftime('%Y/%m/%d')#]]
        vim.fn.winrestview(v)
    end,
})
