local map = vim.keymap.set

-- Editing --

---- Config Files ----

map('n', '<Leader>ve', function() vim.cmd(string.format('Files %s/lua/vimrc', vim.fn.stdpath('config'))) end, {
    desc = 'edit vimrc files'
})

map('n', '<Leader>F', function() vim.cmd(string.format('tabnew %s/ftplugin/%s.lua', vim.fn.stdpath('config'), vim.o.filetype)) end, {
    desc = 'edit filetype plugin of current filetype',
})

map('n', '<Leader>S', ':UltiSnipsEdit<CR>', {
    desc = 'edit UltiSnips snippet definition of current filetype',
})

--[[ if vim.fn.exists(':ExrcSource') then
    map('n', '<Leader>L', function() vim.cmd(string.format("tabnew %s", 'exrc-broken')) end, {
        desc = 'Edit local vimrc file (exrc.nvim)'
    })
elseif isLoaded('vim-localrc') then
    map('n', '<Leader>L', function()
        vim.cmd(string.format('tabnew %s', vim.fn.join(vim.g['localrc#search'](vim.g.localrc_filename), ' ')))
        end, {
            desc = 'Edit local vimrc file (vim-localrc)',
    })
end ]]

---- Text Manipulation ----

map('n', '<F2>', ':set paste! paste?<CR>', { desc = "toggle 'paste'" })

map('i', 'jk', '<esc>', { desc = 'exit intert mode more comfortably' })

map({'i','n'}, '<Leader>s', function() vim.cmd 'wa' end, { desc = 'save files' })

---- File Manipulation ----

map('n', '<Leader>gf', ':e <cfile><CR>', { desc = "'gf' but make it create new file if not existant" })

---- Handy Mappings ----

map('n', '<Leader>{', function()
        local cs = vim.o.commentstring
        vim.fn.append('.', { string.format(cs,' {{{'), string.format(cs,' }}}') })
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

-- Registers --

map('i', '<A-p>', '<c-r>"', { desc = 'paste text in " register more easily in insert mode' })

---- Macros ----

map('n', 'Q', '@', { desc = 'execute macros more comfortably (and remove unnecessary ex mode, see :h gQ)' })

-- map('n', '<space>', '@q', { desc = 'conveniently execute macro in register 'q'' })
-- map('n', '<c-space>', ':let @q=""<CR>', { desc = "empty the 'q' register to avoid running a macro by accident" })

-- Settings --

map({'n','v','o'}, '<F5>', ':set wrap! wrap?<CR>', { desc = 'Toggle line wrapping' })

-- Interface --

-- Toggle highlighting stuff {{{
map('n', '<Leader>hs', ':set hlsearch! hlsearch?<CR>')
map('n', '<Leader>hl', ':set cursorline! cursorline?<CR>')
map('n', '<Leader>hc', ':set cursorcolumn! cursorcolumn?<CR>')
map('n', '<Leader>hf', ':call ToggleFoldcolumn()<CR>') -- TODO: implement function
-- }}}

map('n', '<F12>', [[:echo '\°O°/'<CR>]])

-- Navigation --


-- navigate windows with ALT+{h,j,k,l} {{{
map({'t','i','n'}, '<A-h>', [[<C-\><C-N><C-w>h]], { desc = 'Navigate window using ALT+h' })
map({'t','i','n'}, '<A-j>', [[<C-\><C-N><C-w>j]], { desc = 'Navigate window using ALT+j' })
map({'t','i','n'}, '<A-k>', [[<C-\><C-N><C-w>k]], { desc = 'Navigate window using ALT+k' })
map({'t','i','n'}, '<A-l>', [[<C-\><C-N><C-w>l]], { desc = 'Navigate window using ALT+l' })
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
map('i', '<a-j>', '<down>')
map('i', '<a-k>', '<up>')
map('i', '<a-l>', '<right>')
-- "}}}


-- vim: fdm=marker
