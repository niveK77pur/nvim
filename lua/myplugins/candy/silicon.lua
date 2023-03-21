return { "narutoxy/silicon.lua",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require('silicon').setup({})
        -- local silicon = require('silicon')
        -- Generate image of lines in a visual selection
        vim.keymap.set('v', '<Leader>S',  function() silicon.visualise_api({ to_clip=true }) end )
        -- Generate image of a whole buffer, with lines in a visual selection highlighted
        -- vim.keymap.set('v', '<Leader>bs', function() silicon.visualise_api({to_clip = true, show_buf = true}) end )
        -- Generate visible portion of a buffer
        -- vim.keymap.set('n', '<Leader>s',  function() silicon.visualise_api({to_clip = true, visible = true}) end )
        -- Generate current buffer line in normal mode
        -- vim.keymap.set('n', '<Leader>s',  function() silicon.visualise_api({to_clip = true}) end )
    end
}
