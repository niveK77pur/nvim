return { 'bkegley/gloombuddy', disable=true,
    requires = 'tjdevries/colorbuddy.vim',
    config = function ()
        require'colorbuddy'.colorscheme('gloombuddy')
    end,
}
