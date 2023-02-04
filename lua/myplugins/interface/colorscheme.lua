local packer_extra = { as = 'colorscheme' }

-- local plugin = require('myplugins.interface.colorscheme-plugins.everforest')
-- local plugin = require('myplugins.interface.colorscheme-plugins.nightfox')
-- local plugin = require('myplugins.interface.colorscheme-plugins.material')
local plugin = require('myplugins.interface.colorscheme-plugins.nebulous')
-- local plugin = require('myplugins.interface.colorscheme-plugins.embark')
-- local plugin = require('myplugins.interface.colorscheme-plugins.pinkmare')
-- local plugin = require('myplugins.interface.colorscheme-plugins.tokyodark')
-- local plugin = require('myplugins.interface.colorscheme-plugins.omni')
-- local plugin = require('myplugins.interface.colorscheme-plugins.gloombuddy')
-- local plugin = require('myplugins.interface.colorscheme-plugins.doom-one')
-- local plugin = require('myplugins.interface.colorscheme-plugins.seoul256')
-- local plugin = require('myplugins.interface.colorscheme-plugins.miramare')
-- local plugin = require('myplugins.interface.colorscheme-plugins.oceanic-next')
-- local plugin = require('myplugins.interface.colorscheme-plugins.onedark')

return vim.tbl_deep_extend('force', plugin, packer_extra)
