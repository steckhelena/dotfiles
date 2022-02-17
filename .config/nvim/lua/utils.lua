local M = {}

M.watch_file = function (fname, on_change)
    local w = vim.loop.new_fs_event()

    w:start(fname, {}, vim.schedule_wrap(function ()
        on_change()
        w:stop()
        M.watch_file(fname, on_change)
    end))
end

M.map = function(modes, key, result, options)
    options = vim.tbl_deep_extend("force", {
        noremap = true,
        silent = true,
        expr = false,
        nowait = false,
    }, options or {})
    local buffer = options.buffer
    options.buffer = nil

    if type(modes) ~= "table" then
        modes = { modes }
    end

    for i = 1, #modes do
        if buffer then
            vim.api.nvim_buf_set_keymap(0, modes[i], key, result, options)
        else
            vim.api.nvim_set_keymap(modes[i], key, result, options)
        end
    end
end

return M
