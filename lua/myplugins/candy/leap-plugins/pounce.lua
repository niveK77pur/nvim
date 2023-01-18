return { 'rlane/pounce.nvim',
    config = function ()
        require'pounce'.setup{
            accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
            accept_best_key = "<enter>",
            multi_window = true,
            debug = false,
        }

        vim.cmd [[
            nmap a <cmd>Pounce<CR>
            nmap A <cmd>PounceRepeat<CR>
            vmap a <cmd>Pounce<CR>
            omap ga <cmd>Pounce<CR>  " 's' is used by vim-surround
        ]]

        -- change colors with :highlight (check ':h pounce.txt')

    end
}
