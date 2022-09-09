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

