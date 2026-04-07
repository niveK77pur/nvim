-- Indentation
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.softtabstop = -1
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Virtual indent
vim.opt.breakindent = true
vim.opt.showbreak = '> '
vim.opt.cpoptions:append('n')

-- Line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Scrolling
vim.opt.wrap = false
vim.opt.sidescroll = 20
vim.opt.sidescrolloff = 5
vim.opt.scrolloff = 5

-- Backup
vim.opt.writebackup = true
vim.opt.backup = true
vim.opt.backupdir:remove('.')
vim.opt.backupdir:append('/tmp/nvim-backupdir')

-- Casing
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = false

-- Everything else...
vim.opt.autowrite = true
vim.opt.exrc = true
vim.opt.fillchars = [[fold: ]]
vim.opt.foldtext = "v:lua.require'utils.functions'.MyFoldText()"
vim.opt.lazyredraw = true -- especially for macros
vim.opt.linebreak = true -- Line wrapping at a word
vim.opt.list = true
vim.opt.listchars = [[tab:>-,trail:×,extends:>,precedes:<,nbsp:+]]
vim.opt.modeline = true
vim.opt.mouse = 'a'
vim.opt.rulerformat = '%-14.(%l,%c%V%) %y %P' -- Adapted from default `statusline`
vim.opt.signcolumn = 'yes' -- avoid sign column to make text area jump around
vim.opt.statuscolumn = [[%{% v:lua.require'utils.functions'.generateStatusColumn() %}]]
vim.opt.winborder = 'rounded'

if vim.fs.basename(vim.o.shell) == 'fish' then
    vim.opt.shell = '/bin/sh'
end
