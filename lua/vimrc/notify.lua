local old_notify = vim.notify

---Overwrite the default `vim.notify` to allow log level filtering. Reads minimum level from `g:notify_log_level`.
---@param msg string|string[] See `h: vim.notify`. A string list will be concatenated with newlines.
---@param level integer? See `h: vim.notify`.
---@param opts table? See `h: vim.notify`. Forwarded to the `vim.notify()` call.
local function my_notify(msg, level, opts)
    local log_level = vim.g.notify_log_level or vim.log.levels.TRACE
    if type(level) == 'number' and level < log_level then
        return
    end
    ---@cast msg string[]
    if vim.fn.type(msg) == vim.v.t_list then
        msg = vim.fn.join(msg, [[\n]])
    end
    old_notify(msg, level, opts)
end

vim.notify = my_notify

vim.g.notify_log_level = vim.log.levels.INFO
