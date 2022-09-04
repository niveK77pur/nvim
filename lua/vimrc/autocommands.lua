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

do -- lua/vimrc/plugins.lua {{{
    function _G.foldexprVIMRCplugins(lnum, POI)
        local line = vim.fn.getline(lnum)

        -- START : Move cursor --
        local view = vim.fn.winsaveview()
        vim.api.nvim_win_set_cursor(0, {lnum,0})

        -- determine current location in the code
        local in_preamble = vim.fn.search([[^return require('packer')\.startup]], 'Wn') > 0
        local in_use = false
        do
            local prev_use = vim.fn.search([[^\s*use\s*{]], 'Wb')
            if prev_use == 0 then -- no fold if there is no previous 'use'
                goto nouse
            end
            vim.cmd[[normal! f{]]
            local prev_use_end = vim.fn.searchpair('{', '', '}', 'n')
            -- cursor is in a line before the closing bracket of use {}
            in_use = (lnum <= prev_use_end)
            ::nouse::
        end

        vim.fn.winrestview(view)
        -- END : Reset cursor --

        if in_preamble then
            -- we are in the 'preamble' (i.e. before packer startup call)
            if line:match('^%-%-') then -- start new fold on commented line
                return '>1'
            elseif line:match('^%s*$') then -- reset fold on empty lines
                return '0'
            end
            return '='
        else
            if line:match("^return require%('packer'%)") then
                -- reset indent when startup begins
                return '0'
            end

            if line:match("^%s*use%s*{.*}") then
                -- no fold if use starts and finishes on same line
                return '0'
            elseif line:match("^%s*use%s*{") then
                return '>1'
            elseif in_use then
                if line:match('config = function') then
                    return '>2'
                end
                return '1'
            else
                return '0'
            end
        end
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
