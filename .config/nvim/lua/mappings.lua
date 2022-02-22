local map = require("utils").map

-- Make ctrl-U and ctrl-W allow to undo changes
map("i", "<c-u>", "<c-g>u<c-u>")
map("i", "<c-w>", "<c-g>u<c-w>")

-- This lets me use C-b to build makefiles
map("n", "<C-b>", ":make<CR>")

-- This unsets the "last search pattern" register by hitting return
map("n", "<CR>", ":noh<CR><CR>")
