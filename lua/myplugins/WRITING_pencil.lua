return {
    'preservim/vim-pencil',
    enabled = true,
    cmd = {
        'PencilToggle',
        'PencilOff',
        'PencilHard',
        'PencilSoft',
    },
    keys = {
        { '<Leader>pt', ':PencilToggle<CR>' },
        { '<Leader>po', ':PencilOff<CR>' },
        { '<Leader>ph', ':PencilHard<CR>' },
        { '<Leader>ps', ':PencilSoft<CR>' },
    },
    event = {
        'FileType jjdescription',
    },
    config = function()
        local augroup_pencil = vim.api.nvim_create_augroup('pencil', {})

        vim.api.nvim_create_autocmd({ 'FileType' }, {
            group = augroup_pencil,
            pattern = { 'jjdescription' },
            desc = 'Setup pencil for jujutsu description',
            callback = function(args)
                local textwidth = vim.bo[args.buf].textwidth
                vim.fn['pencil#init']({
                    -- textwidth = 12, -- does not seem to work?
                    wrap = 'hard',
                })
                vim.bo[args.buf].textwidth = textwidth
            end,
        })
    end,
}
