return { 'nvim-treesitter/playground',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = { 'TSPlaygroundToggle' },
    build = ':TSInstall query',
}
