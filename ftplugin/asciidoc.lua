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

