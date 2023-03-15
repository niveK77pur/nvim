return { 'bkegley/gloombuddy',
    dependencies = { 'tjdevries/colorbuddy.vim' },
    config = function ()
        require'colorbuddy'.colorscheme('gloombuddy')
    end,
}
