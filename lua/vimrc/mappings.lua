local map = vim.keymap.set

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                    Editing
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Config Files ----------------------------------------------------------------

map('n', '<Leader>ve', function()
        -- for telescope: https://github.com/nvim-telescope/telescope.nvim#lists-picker
        if require('vimrc.functions').plugin_loaded('fzf-lua') then
            require('fzf-lua').files{ cwd = vim.fn.stdpath('config') .. '/lua/vimrc' }
        elseif require('vimrc.functions').plugin_loaded('fzf.vim') then
            vim.cmd(('Files %s/lua/vimrc'):format(vim.fn.stdpath('config')))
        end
    end, {
    desc = 'edit vimrc files'
})

map('n', '<Leader>vp', function()
        require('fzf-lua').files{ cwd = vim.fn.stdpath('config') .. '/lua/myplugins' }
    end, {
    desc = 'edit plugin files'
})

map('n', '<Leader>F', function() vim.cmd(('tabnew %s/ftplugin/%s.lua'):format(vim.fn.stdpath('config'), vim.o.filetype)) end, {
    desc = 'edit filetype plugin of current filetype',
})

map('n', '<Leader>S', ':UltiSnipsEdit<CR>', {
    desc = 'edit UltiSnips snippet definition of current filetype',
})

--[[ if vim.fn.exists(':ExrcSource') then
    map('n', '<Leader>L', function() vim.cmd(("tabnew %s":format('exrc-broken')) end, {
        desc = 'Edit local vimrc file (exrc.nvim)'
    })
elseif isLoaded('vim-localrc') then
    map('n', '<Leader>L', function()
        vim.cmd(('tabnew %s':format(vim.fn.join(vim.g['localrc#search'](vim.g.localrc_filename), ' ')))
        end, {
            desc = 'Edit local vimrc file (vim-localrc)',
    })
end ]]

-- Text Manipulation -----------------------------------------------------------

map('n', '<F2>', ':set paste! paste?<CR>', { desc = "toggle 'paste'" })

map('i', 'jk', '<esc>', { desc = 'exit intert mode more comfortably' })

map({'i','n'}, '<Leader>s', function() vim.cmd 'wa' end, { desc = 'save files' })

-- File Manipulation -----------------------------------------------------------

map('n', '<Leader>gf', ':e <cfile><CR>', { desc = "'gf' but make it create new file if not existant" })

-- Handy Mappings --------------------------------------------------------------

map('n', '<Leader>{', function()
        local cs = vim.o.commentstring
        cs = cs:gsub('%%[^s]', '%%%0') -- % -> %%
        vim.fn.append('.', { cs:format(' {{{'), cs:format(' }}}') })
    end, {
        desc = "add '{{{' and '}}}' markings for folding"
})

-- the custom [>VIM<] tag "{{{
map('i', '<Leader>j', '[>VIM<] ', { desc = 'insert a [>VIM<] to jump to' })

map('n', '<Leader>j', [[/\[>VIM<\]<CR>]], { desc = 'jump to next [>VIM<] tag' })

-- map({'i', 'n'}, '<Leader><c-space>', function()
--         vim.cmd [[normal! /\[>VIM<\]<CR>v//e<CR>s]]
--     end, {
--         desc = 'jump to and replace next [>VIM<] tag', -- TODO: not working!?
-- })
vim.cmd [[nnoremap <Leader><c-space> /\[>VIM<\]<CR>v//e<CR>s]]
-- }}}

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Registers
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

map('i', '<A-p>', '<c-r>"', { desc = 'paste text in " register more easily in insert mode' })

-- Macros ----------------------------------------------------------------------

-- map('n', 'Q', '@', { desc = 'execute macros more comfortably (and remove unnecessary ex mode, see :h gQ)' })
map('x', 'Q', function() -- {{{
        -- Inspiration:
        --  https://stackoverflow.com/a/3338360
        --  https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db#.10y7wvl5y

        local v_start, v_end = require('vimrc.functions').getvpos()
        vim.api.nvim_feedkeys('\027', 'nt', false) -- <ESC> to finish visual selection before opening NUI input field

        require('vimrc.functions').nuiInput{
            text = "Register",
            on_change = function(value)
                if #value > 0 then
                    vim.api.nvim_feedkeys('\013', 'nt', false) -- <CR> after single character
                end
            end,
            on_submit = function(register)

                if register and register == '' then
                    return
                end

                require('vimrc.functions').nuiInput{
                    text = "Regex",
                    default = [[^..*$]],
                    on_submit = function(regex)
                        vim.cmd( ([[%d,%dg#%s#normal @%s]]):format(
                        v_start[2], v_end[2], regex, register
                        ))
                    end,
                }

            end,
        }
    end, { desc = 'execute macros more comfortably (on every line matching a pattern)' })
-- }}}

-- map('n', '<space>', '@q', { desc = 'conveniently execute macro in register 'q'' })
-- map('n', '<c-space>', ':let @q=""<CR>', { desc = "empty the 'q' register to avoid running a macro by accident" })

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Settings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

map({'n','v','o'}, '<F5>', ':set wrap! wrap?<CR>', { desc = 'Toggle line wrapping' })

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Interface
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Toggle highlighting stuff {{{
map('n', '<Leader>hs', ':set hlsearch! hlsearch?<CR>')
map('n', '<Leader>hl', ':set cursorline! cursorline?<CR>')
map('n', '<Leader>hc', ':set cursorcolumn! cursorcolumn?<CR>')
map('n', '<Leader>hf', ':call ToggleFoldcolumn()<CR>') -- TODO: implement function
-- }}}

map('n', '<F12>', [[:echo '\°O°/'<CR>]])

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  Navigation
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- navigate windows with CTRL+ALT+{h,j,k,l} {{{
map({'t','i','n'}, '<C-A-h>', [[<C-\><C-N><C-w>h]], { desc = 'Navigate window using ALT+h' })
map({'t','i','n'}, '<C-A-j>', [[<C-\><C-N><C-w>j]], { desc = 'Navigate window using ALT+j' })
map({'t','i','n'}, '<C-A-k>', [[<C-\><C-N><C-w>k]], { desc = 'Navigate window using ALT+k' })
map({'t','i','n'}, '<C-A-l>', [[<C-\><C-N><C-w>l]], { desc = 'Navigate window using ALT+l' })
-- }}}

-- use ALT+{, .} to navigate tabs {{{
map({'t','i','n'}, '<A-,>', [[<C-\><C-N>:tabprevious<CR>]], { desc = 'Navigate tabs using ALT+,' })
map({'t','i','n'}, '<A-.>', [[<C-\><C-N>:tabnext<CR>]],     { desc = 'Navigate tabs using ALT+.' })
-- }}}

-- use arrow keys to move linewise on wrapped lines {{{
map('n', '<up>',   'g<up>')
map('n', '<down>', 'g<down>')
map('i', '<up>',   '<c-o>g<up>')
map('i', '<down>', '<c-o>g<down>')
-- }}}

-- " use ALT+{h,j,k,l} to move cursor in insert mode "{{{
map('i', '<a-h>', '<left>')
map('i', '<a-j>', '<c-o>g<down>')
map('i', '<a-k>', '<c-o>g<up>')
map('i', '<a-l>', '<right>')
-- "}}}

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                     Handy
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- map('n', '<CR>', [[:buffer #<CR>]])
-- map('x', '<CR>', [[:buffer #<CR>]])

-- vim: fdm=marker
