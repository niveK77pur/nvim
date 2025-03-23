return {
    enabled = function()
        local function isInstalled(expr)
            return vim.fn.executable(expr) == 1
        end
        return isInstalled('cargo') and isInstalled('rustc')
    end,
    'eraserhd/parinfer-rust',
    build = 'cargo build --release',
    ft = { 'yuck' },
}
