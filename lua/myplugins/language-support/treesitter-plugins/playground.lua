return { 'nvim-treesitter/playground',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    enabled = true,
    cmd = { 'TSPlaygroundToggle' },
    build = ':TSInstall query',
}
