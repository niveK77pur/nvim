return {
    'SirVer/ultisnips',
    enabled = false,
    config = function()
        vim.g.UltiSnipsEditSplit = 'tabdo'
        vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath('config') .. '/UltiSnips' }
    end,
}
