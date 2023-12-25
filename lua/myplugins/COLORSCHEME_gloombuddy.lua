return {
    'bkegley/gloombuddy',
    enabled = false,
    dependencies = { 'tjdevries/colorbuddy.vim' },
    config = function()
        require('colorbuddy').colorscheme('gloombuddy')
    end,
}
