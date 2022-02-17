local function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)")
end

local colorFile = script_path() .. "../theme.vim"

local function reload()
    vim.cmd("source " .. colorFile)
end

local w = vim.loop.new_fs_event()
local on_change
local function watch_file(fname)
    w:start(fname, {}, vim.schedule_wrap(on_change))
end
on_change = function()
    reload()
    -- Debounce: stop/start.
    w:stop()
    watch_file(colorFile)
end

-- reload vim config when background changes
watch_file(colorFile)
reload()
