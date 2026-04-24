-- Templates/Skeletons for new files

local skeleton_map = {
    ['*.pas'] = vim.fn.stdpath('config') .. '/skeletons/Pascal/template_consoleApp.pas',
    ['*.py'] = vim.fn.stdpath('config') .. '/skeletons/Python/HashBang.py',
    ['*.lua'] = vim.fn.stdpath('config') .. '/skeletons/Lua/HashBang.py',
    ['*.sh'] = vim.fn.stdpath('config') .. '/skeletons/Bash/HashBang.sh',
    ['*.yml'] = vim.fn.stdpath('config') .. '/skeletons/Yaml/new.yml',
    ['*.tex'] = vim.fn.stdpath('config') .. '/skeletons/Latex/new.tex',
    ['*.swift'] = vim.fn.stdpath('config') .. '/skeletons/Swift/foundation.swift',
    ['*.html'] = vim.fn.stdpath('config') .. '/skeletons/HTML/new.html',
    ['description.txt'] = vim.fn.stdpath('config') .. '/skeletons/Miscellaneous/Youtube_description.txt',
    ['description.adoc'] = vim.fn.stdpath('config') .. '/skeletons/Miscellaneous/Youtube_description.adoc',
    ['flake.nix'] = vim.fn.stdpath('config') .. '/skeletons/Nix/new-flake.nix',
}

local augroup_skeletons = vim.api.nvim_create_augroup('skeletons', {})
for extension, file in pairs(skeleton_map) do
    vim.api.nvim_create_autocmd('BufNewFile', {
        group = augroup_skeletons,
        pattern = { extension },
        desc = ('Insert skeleton on %s'):format(extension),
        command = ('0r %s'):format(file),
    })
end
