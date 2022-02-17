local utils = require("utils")

local colorFile = vim.fn.expand("~/.config/nvim/").. "theme.vim"

local function reload()
    vim.cmd("source " .. colorFile)
end

-- reload vim config when background changes
utils.watch_file(colorFile, reload)
reload()
