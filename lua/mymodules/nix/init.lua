local function notify_err(text)
    vim.notify(text, vim.log.levels.ERROR, {
        group = 'ftplugin-nix',
        annote = ':NixNestAttributes',
    })
end

---Return the attribute node at the cursor, if any. Also performs some checks on the current node.
---@return TSNode?
local function NixGetCursorAttributeNode() --  {{{1
    local cursor_node = vim.treesitter.get_node()
    if cursor_node == nil then
        notify_err('Failed to get node at cursor')
        return
    elseif not ((cursor_node:type() == 'identifier') and (cursor_node:parent():type() == 'attrpath')) then
        -- Needs to be matching `(attrpath attr: (identifier))`
        notify_err('Cusor is not on an attribute node')
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
            notify_err('Could not find surrounding `attrset_expression` on cursor position')
            return nil
        end
        node = parent
    until node:type() == 'attrset_expression'
    return node
end -- }}}1

---Collect the attributes in the attribute path that follow the attribute at the node; left of the `=`
---@param node TSNode
---@return string?
local function NixGetAttributesAfterNode(node) -- {{{1
    local node_attrs = {}
    local sibling = node:next_named_sibling()
    while sibling ~= nil do
        table.insert(node_attrs, vim.treesitter.get_node_text(sibling, 0))
        sibling = sibling:next_named_sibling()
    end
    if #node_attrs == 0 then
        return nil
    end
    return vim.fn.join(node_attrs, '.')
end -- }}}1

---Collect the remaining nodes of the attribute path on the cursor; right of the `=`
---@param node TSNode
---@return TSNode?
local function NixGetAttributePathValueAfterNode(node) --  {{{
    local node_value = node:parent():next_named_sibling()
    if node_value == nil then
        notify_err('Current attribute does not seem to have any value assigned')
        return
    end
    return node_value
end --  }}}

---Collect the entire binding expression (i.e. `x = y;`)
---@param node TSNode
---@return TSNode?
local function NixGetBindingAtNode(node) --  {{{
    local node_value = node:parent():parent()
    if node_value == nil then
        notify_err('Current attribute does not seem to be part of a binding/assignment')
        return
    end
    return node_value
end --  }}}

local M = {}

function M.nix_nest_attributes() -- {{{1
    local buffer = vim.api.nvim_get_current_buf()

    -- get text of nix attribute cursor is at
    -- TODO: Get common denominator of selected node. This is important when we
    -- have `x.y.z` with our cursor on `y` or `z`. This should be achieved by
    -- capturing `x.y` or `x.y.z` respectively. Accordingly, merging of
    -- attributes should take this into account and further reformat the given
    -- attribute set in order to accomodate for everything.
    local cursor_node = NixGetCursorAttributeNode()
    if cursor_node == nil then
        return
    end
    local cursor_attribute_name = vim.treesitter.get_node_text(cursor_node, 0)

    -- find scope of cursor in which nix attribute is found
    local cursor_scope_node = NixGetAttrssetScopeNode(cursor_node)
    if cursor_scope_node == nil then
        return
    end

    -- get all other instances of the given nix attribute in the same level
    local query = vim.treesitter.query.parse(
        'nix',
        string.format([[(attrpath attr: (identifier) @attribute (#eq? @attribute "%s"))]], cursor_attribute_name)
    )
    local query_captures = query:iter_captures(
        cursor_scope_node,
        buffer,
        nil,
        nil,
        -- limit depth to only obtain first level attributes (not nested)
        { max_start_depth = 3 }
    )

    -- capture all repeated nodes information for modifying the buffer
    local _, first_node = query_captures()
    -- TODO: Check if first node has a known value assigned for the insertion
    local first_node_value = NixGetAttributePathValueAfterNode(first_node)
    if first_node_value == nil then
        return
    end
    local first_node_type = first_node_value:type()
    local _, _, fer, fec = first_node_value:range()
    ---@type integer[][] List of sr,sc,er,ec to be deleted from the buffer
    local delete_list = {}
    ---@type string[][] List of tuples of strings from other nodes to be added; 1 = attribute path, 2 = attribute value
    local add_list = {}
    for _, node in query_captures do
        local node_attrs_text = NixGetAttributesAfterNode(node)
        if node_attrs_text == nil then
            return
        end

        local node_value = NixGetAttributePathValueAfterNode(node)
        if node_value == nil then
            return
        end

        local binding = NixGetBindingAtNode(node)
        if binding == nil then
            return
        end

        local brs, brc, bcs, bce = binding:range()
        -- INFO: Insert in reverse to delete from bottom to top; this avoids having
        -- to recalculate the row numbers
        table.insert(delete_list, 1, {
            brs,
            brc - 1,
            bcs,
            bce,
        })
        -- INFO: Insert in reverse to insert at same position in buffer; this
        -- avoids having to recalculate the column numbers
        -- TODO: Capture comments attached to the node in question?
        table.insert(add_list, 1, {
            node_attrs_text,
            vim.treesitter.get_node_text(node_value, 0),
        })
    end

    -- delete text of other nodes
    for _, ranges in ipairs(delete_list) do
        local sr, sc, er, ec = unpack(ranges)
        vim.api.nvim_buf_set_text(buffer, sr, sc, er, ec, {})
    end

    -- insert text into first node
    for _, entries in ipairs(add_list) do
        local attr, val = unpack(entries)
        -- TODO: Refactor into a table to capture known types more easily
        if first_node_type == 'attrset_expression' then
            vim.api.nvim_buf_set_text(buffer, fer, fec - 1, fer, fec - 1, { string.format('%s = %s;', attr, val) })
        else
            notify_err('Unknown value type encountered for first node: ' .. first_node_type)
            return
        end
    end
end -- }}}1

function M.nix_unnest_attributes() -- {{{1
end -- }}}1

return M

-- vim: fdm=marker
