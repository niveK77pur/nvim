-- VIMSCRIPT Code From Original VIMRC
--
-- " templates/skeletons for new files "{{{
-- augroup script_templates
--         "insert templete on :new *.filetype
--         autocmd!
--         au BufNewFile *.pas   0r $HOME/.vim/skeletons/Pascal/template_consoleApp.pas
--         au BufNewFile *.py    0r $HOME/.vim/skeletons/Python/HashBang.py
--         au BufNewFile *.lua   0r $HOME/.vim/skeletons/Lua/HashBang.py
--         au BufNewFile *.sh    0r $HOME/.vim/skeletons/Bash/HashBang.sh
--         au BufNewFile *.yml   0r $HOME/.vim/skeletons/Yaml/new.yml
--         au BufNewFile *.tex   0r $HOME/.vim/skeletons/Latex/new.tex
--         au BufNewFile *.swift 0r $HOME/.vim/skeletons/Swift/foundation.swift
--         au BufNewFile *.html  0r $HOME/.vim/skeletons/HTML/new.html
--         "au BufNewFile *.ly  call NewLilypond()
-- 
--         au BufNewFile description.txt 0r $HOME/.vim/skeletons/Miscellaneous/Youtube_description.txt
-- augroup END
-- "}}}


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  VIMRC Files
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local augroup_MyVIMRC = vim.api.nvim_create_augroup('MyVIMRC', {})

-- Folding ---------------------------------------------------------------------

local function setFoldLevelRegion(level, row_nr, row_start, row_end)
    if row_nr == row_start then -- the fold starts
        return ('>%s'):format(level)
    elseif row_nr == row_end then -- the fold ends
        return ('<%s'):format(level)
    elseif row_nr > row_start and row_nr < row_end then -- inside fold block
        return '='
    end
    return nil
end

do -- lua/vimrc/functions.lua {{{
    function _G.foldexprVIMRCfunctions(lnum)
        local parser = vim.treesitter.get_parser(0)
        local tree = parser:parse()
        local root = tree[1]:root()

        local query = vim.treesitter.parse_query(parser:lang(), [[
            (function_declaration) @fnblock
        ]])

        for _, match, _ in query:iter_captures(root,0) do
            local r1, c1, r2, c2 = match:range()
            local fold_level = setFoldLevelRegion(1, lnum, r1+1, r2+1)
            if fold_level then
                return fold_level
            end
        end
        return '='
    end
    vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = augroup_MyVIMRC,
        pattern = { ('%s/lua/vimrc/functions.lua'):format(vim.fn.stdpath('config')) },
        desc = "Set foldexpr for 'vimrc.function' module file",
        callback = function()
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.foldexprVIMRCfunctions(v:lnum)'
        end,
    })
end -- }}}

-- TODO optimize loops??
-- Idea: seperate query_use to seperately query 'startup' and then 'use' (similar to query_usearg is done)
do -- lua/vimrc/plugins.lua {{{
    function _G.foldexprVIMRCplugins(lnum)
        local parser = vim.treesitter.get_parser(0)
        local tree = parser:parse()
        local root = tree[1]:root()

        local query_use = vim.treesitter.parse_query( -- {{{
            parser:lang(), [[
            (return_statement
              (expression_list
                (function_call
                  (arguments
                    (table_constructor
                      (field
                        (function_definition
                          (block
                            (function_call
                              (identifier) @fname (#eq? @fname "use")
                            ) @use
                          )
                        )
                      )
                    )
                  )
                ) 
              )
            ) @startup
        ]]) -- }}}
        local query_usearg = vim.treesitter.parse_query( -- {{{
            parser:lang(), [[
              (arguments (
                table_constructor
                  (field
                    (identifier) @fusename (#any-of? @fusename "config" "setup")
                  ) @usearg
                )
              )
        ]]) -- }}}

        for _, match, _ in query_use:iter_matches(root,0) do
            local use, startup = match[2], match[3]

            local psr1, _, _, _ = startup:range()
            if lnum < (psr1+1) then
                -- we are in the 'preamble' (i.e. before packer startup call)
                local line = vim.fn.getline(lnum)
                if line:match('^%-%-') then -- start new fold on commented line
                    return '>1'
                elseif line:match('^%s*$') then -- reset fold on empty lines
                    return '0'
                end
                return '='
            end

            local ur1, _, ur2, _ = use:range()

            if lnum == (ur1+1) and lnum == (ur2+1) then
                return '0'
            end

            local use_level = setFoldLevelRegion(1, lnum, ur1+1,  ur2+1)
            if use_level then
                -- fold inner 'config' blocks
                -- for _, usematch, _ in query_usearg:iter_matches(use,0) do
                --     local uar1, _, uar2, _ = usematch[2]:range()
                --     local usearg_level = setFoldLevelRegion(2, lnum, uar1+1, uar2+1)
                --     if usearg_level then
                --         return usearg_level
                --     end
                -- end
                return use_level
            end

        end
        return '='

    end
    vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = augroup_MyVIMRC,
        pattern = { ('%s/lua/vimrc/plugins.lua'):format(vim.fn.stdpath('config')) },
        desc = "Set foldexpr for 'vimrc.plugins' module file",
        callback = function()
            -- vim.wo.foldcolumn = '4'
            vim.wo.foldmethod = 'expr'
            vim.g.foldstate = { preamble = true, packer = false, }
            vim.b.points_of_interest = {  }
            vim.wo.foldexpr = 'v:lua.foldexprVIMRCplugins(v:lnum, b:points_of_interest)'
        end,
    })
end -- }}}

do -- UltiSnips snippet files {{{
    vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = augroup_MyVIMRC,
        pattern = { "*.snippets" },
        desc = "Set foldexpr for UltiSnips snippet files",
        callback = function()
            vim.wo.foldlevel = 0
        end,
    })
end -- }}}

-- vim: fdm=marker
