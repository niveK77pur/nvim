--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                     Files
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.opt.autowrite = true

vim.g.tex_flavor = 'latex'

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                 Colorschemes
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.cmd([[
if &t_Co > 255 && $TERM !=# "linux"
    " $TERM ==# 'linux' if it is running in a tty
    if has('termguicolors')
        set termguicolors
    endif
    if !has('nvim')
        let &t_8f = "\<esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<esc>[48;2;%lu;%lu;%lum"
    endif
endif
]])

if require('lazy.core.config').plugins['pinkmare'] then
    vim.cmd.colorscheme('pinkmare')
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                            Options for indentation
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.softtabstop = -1
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.o.showbreak = '> '

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Interface
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.opt.mouse = 'a'
vim.opt.relativenumber = true
vim.opt.linebreak = true -- Line wrapping at a word
vim.opt.lazyredraw = true -- especially for macros

vim.opt.wrap = false
vim.opt.sidescroll = 20
vim.opt.sidescrolloff = 5
vim.opt.listchars = [[tab:>-,trail:×,extends:>,precedes:<]]
-- vim.opt.listchars = [[eol:¶,tab:>-,space:∙,trail:×,extends:>,precedes:<]]
vim.opt.list = true

-- status line set up {{{
-- see :h stl
vim.opt.laststatus = 2 -- show statusline: always
vim.opt.statusline =
    [[%<]] .. -- truncate long lines
    [[%F]] .. -- Name of the file
    [[%=]] .. -- left and right side
    [[ %m]] .. -- modified flag
    [[ %Y]] .. -- FileType in the buffer
    [[ %03l/%L]] .. -- current line and total lines
    [[,%02c]] .. -- column number
    [[%V]] .. -- Virtual column number (not displayed if equal to %c)
    [[ %P]]
-- }}}

-- status column set up {{{
-- see :h stc
function _G.generateStatusColumn()
    local elements = {
        [[%C]], -- fold column(?)
        [[%s]], -- sign column
        [[%=]], -- left and right side
    }

    -- line numbers
    local linenumbers = false
    if vim.o.relativenumber and not vim.o.number then
        table.insert(elements, [[%r]])
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
vim.opt.statuscolumn = [[%{% v:lua._G.generateStatusColumn() %}]]
-- }}}

local fold_fill_char = '.'
local lnum_far_right = false
function _G.MyFoldText(fc) -- {{{
    -- https://www.reddit.com/r/neovim/comments/opznf4/custom_foldtext_in_lua/
    local fillchar = fc or fold_fill_char
    local folding_sign = ''
    local num_lines_folded = vim.v.foldend - vim.v.foldstart
    local foldline = {
        spaces = vim.fn.substitute(vim.fn.getline(vim.v.foldstart), [[^\s*\zs.*]], '', ''),
        text = vim.fn.substitute(vim.fn.getline(vim.v.foldstart), [[^\s*]], '', ''),
    }
    local line = {
        left = string.format("%s%s {lvl.%d} %s ", foldline['spaces'], folding_sign, vim.v.foldlevel,
            vim.fn.substitute(foldline['text'], string.format([[\s*%s\d*\s*]], vim.fn.split(vim.o.foldmarker,',')[1]), '', '')),
        right = string.format("[%dL]", num_lines_folded),
    }
    -- Take into account line number column. It breaks when more columns are needed than specified, as there is no way to obtain the "effective" number column width. (i.e. the default value of 4 allows for line numbers up to 999; if you have line number 1000, then it will implicitly use 5 colums. There is no way to tell this. A hack is implemented by conditionally substracting the corresponding value.
    local fillcharcount
    if not lnum_far_right then -- put Line number at 'textwidth'
        fillcharcount = ((vim.o.textwidth>0) or 80) - #line.left - #line.right
    else -- put Line number at the very right edge
        fillcharcount = vim.api.nvim_win_get_width(0) - #line.left - #line.right
           - ( (vim.o.number or vim.o.relativenumber or 0) and math.max(vim.o.numberwidth, vim.o.relativenumber and -1 or #tostring(vim.fn.line('$'))+1 ) )
        --   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^      ^^^^^^^^                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        --   if no line numbers are set, do not substract anything
        --                                                  otherwise try to determine how wide the number column is
        --                                                                              if relative number is used, then 'numberwidth' should be fine (?)
        --                                                                              otherwise, take the number of lines in the buffer (+1; see :h numberwidth)
    end
    -- Hard-coded value adjustment due to Nerd Font icon character length not
    -- being correctly computed.
    fillcharcount = fillcharcount + 2
    -- 'repeat' is a lua keyword, we need to use a different syntax to call the function
    return line['left'] .. vim.fn['repeat'](fillchar, fillcharcount) .. line['right']
end -- }}}
vim.opt.foldtext = 'v:lua.MyFoldText()'
vim.opt.fillchars = [[fold: ]]
-- vim.opt.fillchars = [[fold:·]]

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                    Editor
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- vim.opt.splitright = true
vim.opt.shiftround = true
vim.opt.modeline = true
vim.opt.writebackup = true
vim.opt.backup = true
vim.opt.backupdir = '/tmp'

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                         Settings for auto-completion
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = false

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  Diagnostics
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim.diagnostic.config({
    float = {
        source = 'if_many',
        focusable = false,
    },
    virtual_text = {
        source = 'if_many',
    },
    severity_sort = true,
    signs = true,
})
-- avoid sign column to make text area jump around
vim.opt.signcolumn = 'yes'

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                     Netrw
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/

vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 30
-- vim.g.netrw_localcopydircmd = 'cp -r'

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                Shell specifics
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if vim.fs.basename(vim.o.shell) == 'fish' then
    vim.opt.shell = '/bin/sh'
end

-- vim: fdm=marker
