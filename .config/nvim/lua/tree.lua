local M = {}

local view = require "nvim-tree.view"

M.toggle_tree = function()
    if view.is_visible() then
        require("nvim-tree").toggle()
        require("bufferline.state").set_offset(0)
    else
        require("bufferline.state").set_offset(31, "File Explorer")
        require("nvim-tree").toggle(true)
    end
end

return M
