local myfs = {}

---@deprecated Prefer vim.ui.select
function myfs.nuiInput(params)
    params.position = params.position or '50%'
    params.width = params.width or 30
    params.text = params.text or 'Input Box'
    params.padding = params.padding or { 1, 1, 1, 1 }
    params.prompt = params.prompt or nil
    params.default = params.default or nil
    params.on_close = params.on_close or nil
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
            style = ({
                'double',
                'none',
                'rounded',
                'shadow',
                'single',
                'solid',
            })[3],
            text = {
                top = params.text,
                top_align = ({ 'left', 'right', 'center' })[3],
            },
            padding = {
                top = params.padding[1],
                left = params.padding[2],
                bottom = params.padding[3],
                right = params.padding[4],
            },
        },
        win_options = {
            winhighlight = 'Normal:Normal,FloatBorder:SpecialChar',
        },
    }, {
        prompt = params.prompt,
        default_value = params.default,
        on_close = params.on_close,
        on_submit = params.on_submit,
        on_change = params.on_change,
    })

    -- mount/open the component
    input:mount()
end

---@deprecated
function myfs.getvpos()
    --[[
        Inspired by https://github.com/ibhagwan/nvim-lua/blob/main/lua/utils.lua#L89

        Function to obtain Visual Mode selection positions. These are not '< and '> since they do not seem accessible from within a lua visual mode mapping (see ':h vim.keymap.set'). Getting these marks requires exiting Visual Mode, which seems impossible to do from within Lua as of now (see https://github.com/neovim/neovim/issues/16843).

        This function is primarily intended to be used in a visual mode mapping. To be used as follows.
            vim.keymap.set('x', LH, function()
                local v_start, v_end = require('utils.functions').getvpos()
                -- Do things;
                -- These variables two variables hold start and end positions of the selection
            end)
    --]]

    -- get positions for '.' and 'v' (see ':h line()')
    local pos_v = vim.fn.getpos('v')
    local pos_d = vim.fn.getpos('.')
    -- 'sort' according to line number (2nd field)
    local v_start = pos_v[2] < pos_d[2] and pos_v or pos_d
    local v_end = pos_v[2] > pos_d[2] and pos_v or pos_d

    return v_start, v_end
end

function myfs.plugin_loaded(plugin_name)
    return myfs.lazy_plugin_loaded(plugin_name)
    -- return myfs.packer_plugin_loaded(plugin_name)
end

function myfs.lazy_plugin_loaded(plugin_name)
    return require('lazy.core.config').plugins[plugin_name]
        and require('lazy.core.config').plugins[plugin_name]._.loaded
end

function myfs.generateStatusColumn()
    local elements = {
        [[%C]], -- fold column(?)
        [[%s]], -- sign column
        [[%=]], -- left and right side
    }

    -- line numbers
    local linenumbers = false
    if vim.o.relativenumber and not vim.o.number then
        table.insert(elements, [[%{v:relnum}]])
        linenumbers = true
    elseif not vim.o.relativenumber and vim.o.number then
        table.insert(elements, [[%l]])
        linenumbers = true
    elseif vim.o.relativenumber and vim.o.number then
        table.insert(elements, [[%{v:relnum ? v:relnum : v:lnum}]])
        linenumbers = true
    end

    -- fancy separator
    if #elements > 0 and linenumbers then
        table.insert(elements, [[│]])
        -- table.insert(elements, [[ ]])
    end

    return vim.fn.join(elements, '')
end

local fold_fill_char = '.'
local lnum_far_right = false
function myfs.MyFoldText(fc)
    -- https://www.reddit.com/r/neovim/comments/opznf4/custom_foldtext_in_lua/

    ---Get the text on the line that should be placed into the foldtext
    ---@param line string The line on which to find the desired text
    ---@return string
    local function get_line_text(line) --  {{{
        -- remove the fold marker
        -- TODO: Remove closing marker
        line =
            vim.fn.substitute(line, string.format([[\s*%s\s*\d*\s*]], vim.fn.split(vim.o.foldmarker, ',')[1]), '', '')
        -- remove the comment characters
        line = vim.fn.substitute(
            line,
            -- assemble 'comments' into a regex pattern where each value is 'OR'ed
            vim.fn.substitute(vim.o.comments, [[\%(^\|,\)[^:]*:]], [[\\|]], 'g'):gsub([[^\|]], ''),
            '',
            'g'
        )
        -- remove surrounding spaces
        line = vim.trim(line)
        return line
    end --  }}}

    ---Continue getting the next line until a non-empty fold text line is found
    ---@param linenr integer The line number to start searching from
    ---@return string
    local function get_next_non_empty_line_text(linenr) --  {{{
        local line
        while line == nil or line == '' or linenr < vim.fn.line('$') do
            line = vim.fn.getline(linenr)
            if get_line_text(line) == '' then
                line = nil
            else
                return line
            end
            linenr = linenr + 1
        end
        return '(EOL)'
    end --  }}}

    local fillchar = fc or fold_fill_char
    local folding_sign = ''
    local num_lines_folded = vim.v.foldend - vim.v.foldstart
    local next_non_empty_line = get_next_non_empty_line_text(vim.v.foldstart)
    local foldline = {
        indent = vim.fn.substitute(next_non_empty_line, [[^\s*\zs.*]], '', ''),
        text = get_line_text(next_non_empty_line),
    }
    local line = {
        left = string.format(
            '%s%s {lvl.%d} %s%s ',
            foldline['indent'],
            folding_sign,
            vim.v.foldlevel,
            vim.fn['repeat']('  ', vim.v.foldlevel - 1),
            foldline['text']
        ),
        right = string.format('[%dL]', num_lines_folded),
    }
    -- Take into account line number column. It breaks when more columns are
    -- needed than specified, as there is no way to obtain the "effective"
    -- number column width. (i.e. the default value of 4 allows for line
    -- numbers up to 999; if you have line number 1000, then it will implicitly
    -- use 5 columns. There is no way to tell this. A hack is implemented by
    -- conditionally subtracting the corresponding value.
    local fillcharcount
    if not lnum_far_right then -- put Line number at 'textwidth'
        fillcharcount = ((vim.o.textwidth > 0) and vim.o.textwidth or 100) - #line.left - #line.right
    else -- put Line number at the very right edge
        fillcharcount = vim.api.nvim_win_get_width(0)
            - #line.left
            - #line.right
            - ( -- if no line numbers are set, do not subtract anything
                (vim.o.number or vim.o.relativenumber or 0)
                -- otherwise try to determine how wide the number column is
                and math.max(
                    -- if relative number is used, then 'numberwidth' should be fine (?)
                    vim.o.numberwidth,
                    -- otherwise, take the number of lines in the buffer (+1; see :h numberwidth)
                    vim.o.relativenumber and -1 or #tostring(vim.fn.line('$')) + 1
                )
            )
    end
    -- Hard-coded value adjustment due to Nerd Font icon character length not
    -- being correctly computed.
    fillcharcount = fillcharcount + 2
    -- 'repeat' is a lua keyword, we need to use a different syntax to call the function
    return line['left'] .. vim.fn['repeat'](fillchar, fillcharcount) .. line['right']
end

return myfs
