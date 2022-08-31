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

do -- lua/vimrc/functions.lua {{{
    function _G.foldexprVIMRCfunctions(lnum)
        local line = vim.fn.getline(lnum)
        if line:match('^function') then
            return 'a1'
        elseif line:match('^end') then
            return 's1'
        else
            return '='
        end
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

