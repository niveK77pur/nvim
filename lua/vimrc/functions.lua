local myfs = {}

function myfs.tstestfunc()
    local v = 'yo'
    local function helper(t)
        return ('>%s<'):format(t)
    end
    local h = function(t)
        return ('<%s>'):format(t)
    end
    return h(helper(v))
end


function myfs.nuiInput(params)
    params.position  = params.position  or "50%"
    params.width     = params.width     or 30
    params.text      = params.text      or 'Input Box'
    params.padding   = params.padding   or {1,1,1,1}
    params.prompt    = params.prompt    or nil
    params.default   = params.default   or nil
    params.on_close  = params.on_close  or nil
    params.on_submit = params.on_submit or nil
    params.on_change = params.on_change or nil

    local input = require('nui.input')({
        position = params.position,
        -- position = -2,
        -- relative = 'cursor',
        size = {
            width = params.width,
        },
        border = {
            style = ({ "double", "none", "rounded", "shadow", "single", "solid" })[3],
            text = {
                top = params.text,
                top_align = ({ "left", "right", "center" })[3],
            },
            padding = {
                top    = params.padding[1],
                left   = params.padding[2],
                bottom = params.padding[3],
                right  = params.padding[4],

            },
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:SpecialChar",
        },
    }, {
        prompt        = params.prompt,
        default_value = params.default,
        on_close      = params.on_close,
        on_submit     = params.on_submit,
        on_change     = params.on_change,
    })

    -- mount/open the component
    input:mount()
end


function myfs.getvpos()

    --[[
        Inspired by https://github.com/ibhagwan/nvim-lua/blob/main/lua/utils.lua#L89

        Function to obtain Visual Mode selection positions. These are not '< and '> since they do not seem accessible from within a lua visual mode mapping (see ':h vim.keymap.set'). Getting these marks requires exiting Visual Mode, which seems impossible to do from within Lua as of now (see https://github.com/neovim/neovim/issues/16843).

        This function is primarily intended to be used in a visual mode mapping. To be used as follows.
            vim.keymap.set('x', LH, function()
                local v_start, v_end = require('vimrc.functions').getvpos()
                -- Do things;
                -- These variables two variables hold start and end positions of the selection
            end)
    --]]

    -- get positions for '.' and 'v' (see ':h line()')
    local pos_v   = vim.fn.getpos("v")
    local pos_d   = vim.fn.getpos(".")
    -- 'sort' according to line number (2nd field)
    local v_start = pos_v[2] < pos_d[2] and pos_v or pos_d
    local v_end   = pos_v[2] > pos_d[2] and pos_v or pos_d

    return v_start, v_end
end


function myfs.GetCommentCharacter()
    -- add stuff before and after comment character
    local pre,post = '', ''
    if vim.o.filetype == 'python' then
        post = ' '
    end
    for _,v in pairs(vim.fn.split(vim.o.comments, ',')) do
        if v:match('^b?:') then
            return pre .. v:match(':(.*)') .. post
        end
    end
    return pre .. '' .. post
end

function myfs.MakeHeader(text)
    local indent = vim.fn.substitute(vim.fn.getline('.'), [[^\s*\zs\S.*]], '', '')
    local comment_character = myfs.GetCommentCharacter()
    local textwidth = (vim.o.textwidth>0) and vim.o.textwidth or 80
    local width = textwidth - #indent - #comment_character
    local space = (' '):rep(vim.fn.round( width/2 - #text/2 ))

    local banner = ("%s%s%s"):format(indent, comment_character, ('~'):rep(width))
    local text_line = ("%s%s%s%s"):format(indent, comment_character, space, text)
    vim.fn.append('.', {
        banner,
        text_line,
        banner,
    })
end

function myfs.MakeSection(text)
    local indent = vim.fn.substitute(vim.fn.getline('.'), [[^\s*\zs\S.*]], '', '')
    local comment_character = myfs.GetCommentCharacter()
    local textwidth = (vim.o.textwidth>0) and vim.o.textwidth or 80
    local width = textwidth - #indent - #comment_character
    text = (' %s '):format(text)

    local banner = ('-'):rep(width - #text)
    local text_line = ("%s%s%s%s"):format(indent, comment_character, text, banner)
    vim.fn.append('.', {
        text_line,
    })
end


function myfs.plugin_loaded(plugin_name)
    return myfs.lazy_plugin_loaded(plugin_name)
    -- return myfs.packer_plugin_loaded(plugin_name)
end

function myfs.lazy_plugin_loaded(plugin_name)
    return require('lazy.core.config').plugins[plugin_name]
        and require('lazy.core.config').plugins[plugin_name]._.loaded
end

function myfs.packer_plugin_loaded(plugin_name)
    return packer_plugins[plugin_name]
        and packer_plugins[plugin_name].loaded
end

function myfs.return_gathered_plugins(require_path, require_names)
    local plugin_specs = {}
    for _, r in ipairs(require_names) do
        table.insert(
            plugin_specs,
            require(string.format(
                "%s.%s",
                require_path,
                r
            ))
        )
    end
    return plugin_specs
end


return myfs
