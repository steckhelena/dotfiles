local M = {}

M.toggle_tree = function()
    require("nvim-tree.api").tree.toggle {
        find_file = true,
    }
end

M.setup = function()
    local view = require "nvim-tree.view"
    local api = require "nvim-tree.api"
    local bufferline = require "bufferline.api"
    local Event = api.events.Event

    local size = 31

    api.events.subscribe(Event.Ready, function(data)
        if view.is_visible() then
            bufferline.set_offset(0)
        else
            bufferline.set_offset(31, "File Explorer")
        end
    end)

    api.events.subscribe(Event.TreeOpen, function()
        bufferline.set_offset(size, "File Explorer")
    end)

    api.events.subscribe(Event.TreeClose, function()
        bufferline.set_offset(0, "File Explorer")
    end)

    api.events.subscribe(Event.Resize, function(new_size)
        size = new_size
        bufferline.set_offset(size, "File Explorer")
    end)
end

return M
