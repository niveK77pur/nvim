local M = {}

local function notify(text, level)
    vim.notify(text, level, { group = 'ftplugin-nix', annote = ':NixNestAttributes' })
end

function M.nix_nest_attributes() -- {{{1
end -- }}}1

function M.nix_unnest_attributes() -- {{{1
end -- }}}1

return M

-- vim: fdm=marker
