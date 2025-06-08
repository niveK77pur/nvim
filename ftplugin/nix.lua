vim.o.tabstop = 2

vim.api.nvim_buf_create_user_command(0, 'NixNestAttributes', function()
    require('mymodules.nix').nix_nest_attributes()
end, {})

vim.api.nvim_buf_create_user_command(0, 'NixUnnestAttributes', function()
    require('mymodules.nix').nix_unnest_attributes()
end, {})

-- vim: fdm=marker
