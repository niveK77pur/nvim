return { 'anuvyklack/pretty-fold.nvim',
    enabled = true,
    config = function()

        local global_setup = {
            sections = {
                left = { 'content', },
                right = {
                    ' ',
                    function() return ("[%dL]"):format(vim.v.foldend - vim.v.foldstart) end,
                    '[', 'percentage', ']',
                }
            },
            matchup_patterns = {
                {  '{', '}' },
                { '%(', ')' }, -- % to escape lua pattern char
                { '%[', ']' }, -- % to escape lua pattern char
            },
            -- add_close_pattern = true,
            process_comment_signs = ({'delete', 'spaces', false})[2]
        }

        local function ft_setup(lang, options) -- {{{
            local opts = vim.tbl_deep_extend('force', global_setup, options)
            -- combine global and ft specific matchup_patterns
            if opts and opts.matchup_patterns and global_setup.matchup_patterns then
                opts.matchup_patterns = vim.list_extend(opts.matchup_patterns, global_setup.matchup_patterns)
            end
            require('pretty-fold').ft_setup(lang, opts)
        end -- }}}

        require('pretty-fold').setup(global_setup)

        ft_setup('lua', { -- {{{
            matchup_patterns = {
                { '^%s*do$', 'end' }, -- do ... end blocks
                { '^%s*if', 'end' },  -- if ... end
                { '^%s*for', 'end' }, -- for
                { 'function[^%(]*%(', 'end' }, -- 'function( or 'function (''
            },
        }) -- }}}

        ft_setup('vim', { -- {{{
            matchup_patterns = {
                { '^%s*function!?[^%(]*%(', 'endfunction' },
            },
        }) -- }}}

    end,
}
