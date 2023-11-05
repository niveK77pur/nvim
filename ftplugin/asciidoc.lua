--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Settings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.opt.commentstring = '// %s'

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Mappings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local nmap = function(LH, RH, args) vim.keymap.set('n', LH, RH, args) end

vim.opt.wrap = true

for _,key in pairs{ 'j', 'k', '0', '$' } do
    nmap(key, 'g'..key, { desc = string.format('remap %s for better text editing', key) })
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                             Convert from Markdown
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.api.nvim_buf_create_user_command(0, 'MDReplaceLink', function(args)
    vim.cmd(
        args.line1
        .. ','
        .. args.line2
        .. 's#\\v\\[([^]]+)\\]%(\\[([^]]+)\\])#{\\2}[\\1]#gc'
    )
end, {range=1})

vim.api.nvim_create_user_command('MDSectionID', function()
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
    local title_line = vim.api.nvim_get_current_line()
    local github_id = vim.fn.substitute(title_line, "\\v[[:space:]]+", [[-]], 'g')
    local github_id = github_id:lower():match("^[=-]+(.*)")
    vim.api.nvim_buf_set_lines(0, cursor_line-1, cursor_line-1, true, { string.format("[#%s]", github_id) })
end, {})
