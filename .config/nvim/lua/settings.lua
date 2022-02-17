local function exists(file)
    local ok = os.rename(file, file)
    return ok
end

local function isdir(path)
    return exists(path .. "/")
end

local undodir = vim.fn.expand "~/.config/nvim/undo"

if not isdir(undodir) then
    os.execute("mkdir -p " .. undodir)
end

local opt = setmetatable({}, {
    __newindex = function(_, key, value)
        vim.o[key] = value
        vim.bo[key] = value
    end,
})

vim.o.termguicolors = true
vim.o.history = 10000
vim.o.ruler = false
vim.o.inccommand = "nosplit"
vim.o.display = "truncate"
vim.o.updatetime = 300

vim.o.scrolloff = 5
vim.o.sidescroll = 5
vim.o.sidescrolloff = 15

vim.opt.list = true
vim.opt.listchars = {
    tab = ">_<",
    trail = "-",
    nbsp = "+",
    eol = "↴",
}

vim.o.mouse = "a"

opt.undofile = true
vim.o.undodir = undodir
vim.o.undolevels = 1000
vim.o.undoreload = 10000

opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 4
opt.textwidth = 80

vim.o.confirm = true

vim.wo.number = true
vim.wo.colorcolumn = "+1"
vim.wo.signcolumn = "yes:1"

vim.o.shortmess = vim.o.shortmess .. "c"
