return { 'bkegley/gloombuddy',
    requires = 'tjdevries/colorbuddy.vim',
    config = function ()
        require'colorbuddy'.colorscheme('gloombuddy')
    end,
}
