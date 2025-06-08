local M = {}

local function notify(text, level)
    vim.notify(text, level, { group = 'ftplugin-nix', annote = ':NixNestAttributes' })
end

---Return the attribute node at the cursor, if any. Also performs some checks on the current node.
---@return TSNode?
local function NixGetCursorAttributeNode() --  {{{1
    local cursor_node = vim.treesitter.get_node()
    if cursor_node == nil then
        notify('Failed to get node at cursor', vim.log.levels.ERROR)
        return
    elseif not ((cursor_node:type() == 'identifier') and (cursor_node:parent():type() == 'attrpath')) then
        -- Needs to be matching `(attrpath attr: (identifier))`
        notify('Cusor is not on an attribute node ', vim.log.levels.ERROR)
        return
    end
    return cursor_node
end -- }}}1

---Find the surrounding `attrset_expression` scope of the node
---@param node TSNode
---@return TSNode?
local function NixGetAttrssetScopeNode(node) -- {{{1
    -- Here we traverse up the tree until we find the surrounding
    -- `attrset_expression` node
    repeat
        local parent = node:parent()
        if parent == nil then
            notify('Could not find surrounding `attrset_expression` on cursor position', vim.log.levels.ERROR)
            return nil
        end
        node = parent
    until node:type() == 'attrset_expression'
    return node
end -- }}}1

function M.nix_nest_attributes() -- {{{1
end -- }}}1

function M.nix_unnest_attributes() -- {{{1
end -- }}}1

return M

-- vim: fdm=marker
