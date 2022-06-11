local M = {}
local mapper = require "mapper"

M.watch_file = function(fname, on_change)
    local w = vim.loop.new_fs_event()

    w:start(
        fname,
        {},
        vim.schedule_wrap(function()
            on_change()
            w:stop()
            M.watch_file(fname, on_change)
        end)
    )
end

local charset = {} -- [0-9a-zA-Z]
do
    for c = 48, 57 do
        table.insert(charset, string.char(c))
    end
    for c = 65, 90 do
        table.insert(charset, string.char(c))
    end
    for c = 97, 122 do
        table.insert(charset, string.char(c))
    end
end

M.randomString = function(length)
    if not length or length <= 0 then
        return ""
    end
    math.randomseed(os.clock() ^ 5)
    return M.randomString(length - 1) .. charset[math.random(1, #charset)]
end

M.map = function(
    modes,
    key,
    result,
    options,
    category,
    unique_identifier,
    description,
    isVirtual
)
    options = vim.tbl_deep_extend("force", {
        noremap = true,
        silent = true,
        expr = false,
        nowait = false,
    }, options or {})
    local buffer = options.buffer
    options.buffer = nil

    category = category or "unidentified"
    unique_identifier = unique_identifier or M.randomString(10)
    description = description or "No description available"
    isVirtual = isVirtual or false

    if type(modes) ~= "table" then
        modes = { modes }
    end

    local map_buf = mapper.map_buf
    local map = mapper.map

    if isVirtual then
        map = mapper.map_virtual
        map_buf = mapper.map_buf_virtual
    end

    for i = 1, #modes do
        if buffer then
            map_buf(
                buffer,
                modes[i],
                key,
                result,
                options,
                category,
                unique_identifier,
                description
            )
        else
            map(
                modes[i],
                key,
                result,
                options,
                category,
                unique_identifier,
                description
            )
        end
    end
end

return M
