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