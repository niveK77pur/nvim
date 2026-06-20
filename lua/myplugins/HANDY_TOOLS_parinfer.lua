return {
    enabled = function()
        local function isInstalled(expr)
            return vim.fn.executable(expr) == 1
        end
        return isInstalled('cargo') and isInstalled('rustc')
    end,
    'eraserhd/parinfer-rust',
    build = 'cargo build --release',
    ft = {
        -- https://github.com/eraserhd/parinfer-rust/blob/7f13acea20f03228f72156cec4fa4e49f0d5d1e5/plugin/parinfer.vim#L310-L317
        'clojure',
        'scheme',
        'lisp',
        'racket',
        'hy',
        'fennel',
        'janet',
        'carp',
        'wast',
        'yuck',
        'dune',
    },
}
