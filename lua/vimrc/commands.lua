local vfn = require "vimrc.functions"

vim.api.nvim_create_user_command('MakeTitle', function(opts)
    print(("..%s.. ..%s.. ..%s.."):format(opts.count, opts.args, opts.fargs))
    local titlefn
    if opts.count == 1 then
        titlefn = vfn.MakeHeader
    elseif opts.count == 2 then
        titlefn = vfn.MakeSection
    else
        titlefn = vfn.MakeSection
    end

    if opts.args and opts.args == '' then
        -- query title with NUI if not specified with the command
        vfn.nuiInput{ text = "Title", width = '70%', on_submit = function(title)
            titlefn(title)
        end }
    else
        titlefn(opts.args)
    end
end, { nargs = '*', count = 1, desc = 'Create title banners (:MakeTitle [<Level>] [<Text>])' })
