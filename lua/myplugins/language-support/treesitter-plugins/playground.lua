return { 'nvim-treesitter/playground',
    requires = 'nvim-treesitter/nvim-treesitter',
    cmd = { 'TSPlaygroundToggle' },
    run = ':TSInstall query',
}
