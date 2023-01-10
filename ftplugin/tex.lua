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
--                                   Functions
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local function labelFromLine(labeltype)
    local line = vim.api.nvim_get_current_line()
    local content = line:match([[\%w+{(.+)}]])

    -- filter contents
    content = content:lower()
    content = content:gsub('[^a-z0-9 ]', '')
    content = content:gsub(' ', '-')

    local newlines = { string.format([[\label{%s:%s}]], labeltype, content) }
    local linenr = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(
        0,
        linenr,
        linenr,
        false,
        newlines
    )
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Mappings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.keymap.set('n', '<LocalLeader>lA', function()
  labelFromLine('sec')
end, { desc = 'Add label to section' })

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
