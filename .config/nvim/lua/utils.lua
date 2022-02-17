local M = {}

M.watch_file = function (fname, on_change)
    local w = vim.loop.new_fs_event()

    w:start(fname, {}, vim.schedule_wrap(function ()
        on_change()
        w:stop()
        M.watch_file(fname, on_change)
    end))
end

return M
