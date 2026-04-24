if not vim.g.neovide then
    return
end

if require('lazy.core.config').plugins['pinkmare'] then
    vim.g.pinkmare_transparent_background = false
    vim.cmd([[colorscheme pinkmare]])
end

vim.g.neovide_scale_factor = 1.0
vim.g.neovide_cursor_vfx_mode = 'pixiedust'
vim.g.neovide_cursor_vfx_particle_density = 70.0
