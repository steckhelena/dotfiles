local map = require("utils").map

---------------------------------------------------------
-- Builtins
---------------------------------------------------------
map(
    "i",
    "<c-u>",
    "<c-g>u<c-u>",
    nil,
    "Builtins",
    "<c-u>",
    "Allows c-u to be undone"
)

map(
    "i",
    "<c-w>",
    "<c-g>u<c-w>",
    nil,
    "Builtins",
    "<c-w>",
    "Allows c-w to be undone"
)

map(
    "n",
    "<CR>",
    ":noh<CR><CR>",
    nil,
    "Builtins",
    "undefine_search_pattern",
    "Unsets the last search pattern register"
)

---------------------------------------------------------
-- LSP
---------------------------------------------------------
map(
    "n",
    "<C-u>",
    "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>",
    nil,
    "LSP",
    "lspsaga_scroll_down",
    "Used to scroll down within lspsaga window"
)
map(
    "n",
    "<C-d>",
    "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>",
    nil,
    "LSP",
    "lspsaga_scroll_up",
    "Used to scroll down within lspsaga window"
)
map(
    "n",
    "<leader>e",
    "<cmd>Lspsaga show_line_diagnostics<cr>",
    nil,
    "LSP",
    "lspsaga_show_line_diagnostics",
    "Show current line diagnostics"
)
map(
    "n",
    "[d",
    "<cmd>Lspsaga diagnostic_jump_prev<cr>",
    nil,
    "LSP",
    "lspsaga_diagnostic_jump_prev",
    "Jump to the previous diagnostic in the file"
)
map(
    "n",
    "]d",
    "<cmd>Lspsaga diagnostic_jump_next<cr>",
    nil,
    "LSP",
    "lspsaga_diagnostic_jump_next",
    "Jump to the previous diagnostic in the file"
)
map(
    "n",
    "gd",
    "<cmd>lua require'telescope.builtin'.lsp_definitions()<CR>",
    nil,
    "LSP",
    "telescope.lsp_definitions()",
    "Open a telescope window with the lsp definitions for the current hovered text or jumps to it if there is only one"
)
map(
    "n",
    "gD",
    "<cmd>lua vim.lsp.buf.declaration()<CR>",
    nil,
    "LSP",
    "vim.lsp.buf.declaration()",
    "Go to the declaration for the current hovered text"
)
map(
    "n",
    "K",
    "<cmd>Lspsaga hover_doc<cr>",
    nil,
    "LSP",
    "lspsaga_hover_doc",
    "Opens a hovering doc window of the currently hovered text"
)
map(
    "n",
    "gi",
    "<cmd>lua require'telescope.builtin'.lsp_implementations()<CR>",
    nil,
    "LSP",
    "telescope.lsp_implementations()",
    "Opens a telescope window with the lsp implementations of the currently hovered text or jumps to it if there is only one"
)
map(
    "n",
    "<C-k>",
    "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    nil,
    "LSP",
    "lsp.signature_help()",
    "Opens a hovering window with the current hovered text signature help"
)
map(
    "n",
    "<leader>wa",
    "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
    nil,
    "LSP",
    "lsp.add_workspace_folder()",
    "Prompts for the user to enter a folder to add to the workspace"
)
map(
    "n",
    "<leader>wr",
    "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
    nil,
    "LSP",
    "lsp.remove_workspace_folder()",
    "Prompts for the user to enter a folder to remove from the workspace"
)
map(
    "n",
    "<leader>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    nil,
    "LSP",
    "lsp.list_workspace_folders()",
    "Prints a list of all the current workspace folders"
)
map(
    "n",
    "<leader><leader>",
    ":lua require'telescope.builtin'.lsp_workspace_symbols()<CR>",
    nil,
    "LSP",
    "telescope.lsp_workspace_symbols()",
    "Opens a telescope window with all the current workspace symbols"
)
map(
    "n",
    "<leader>D",
    "<cmd>lua require'telescope.builtin'.lsp_type_definitions()<CR>",
    nil,
    "LSP",
    "telescope.lsp_type_definitions()",
    "Opens a telescope windows with type definitions for the currently hovered text"
)
map(
    "n",
    "<leader>rn",
    "<cmd>Lspsaga rename<cr>",
    nil,
    "LSP",
    "lspsaga.rename",
    "Opens a hovering window for renaming the currently hovered text"
)
map(
    "n",
    "<leader>ca",
    "<cmd>Lspsaga code_action<cr>",
    nil,
    "LSP",
    "lspsaga.code_action",
    "Opens a hovering window where the user can select among code actions for the hovered line"
)
map(
    "x",
    "<leader>ca",
    ":<c-u>Lspsaga range_code_action<cr>",
    nil,
    "LSP",
    "lspsaga.range_code_action",
    "Opens a hovering window where the user can select among code actions for selected text"
)
map(
    "n",
    "gr",
    "<cmd>lua require'telescope.builtin'.lsp_references()<CR>",
    nil,
    "LSP",
    "telescope.lsp_references",
    "Opens a telescope window with lsp references for the currently hovered text or jumps to the reference if there is only one"
)
map(
    "n",
    "<leader>f",
    "<cmd>lua vim.lsp.buf.format{ async = true }<CR>",
    nil,
    "LSP",
    "lsp.formatting()",
    "Formats the current buffer if supported by the LSP"
)

---------------------------------------------------------
-- barbar
---------------------------------------------------------
map(
    "n",
    "<A-,>",
    ":BufferPrevious<CR>",
    nil,
    "barbar",
    "buffer_previous_,",
    "Go to previous buffer"
)
map(
    "n",
    "<A-.>",
    ":BufferNext<CR>",
    nil,
    "barbar",
    "buffer_next_,",
    "Go to next buffer"
)
map(
    "n",
    "≤",
    ":BufferPrevious<CR>",
    nil,
    "barbar",
    "buffer_previous_≤",
    "Go to previous buffer"
)
map(
    "n",
    "≥",
    ":BufferNext<CR>",
    nil,
    "barbar",
    "buffer_next_≥",
    "Go to next buffer"
)
map(
    "n",
    "<A-<>",
    ":BufferMovePrevious<CR>",
    nil,
    "barbar",
    "buffer_move_previous",
    "Move buffer to previous position"
)
map(
    "n",
    "<A->>",
    " :BufferMoveNext<CR>",
    nil,
    "barbar",
    "buffer_mode_next",
    "Move buffer to next position"
)
map(
    "n",
    "<leader>d",
    ":BufferClose<cr>",
    nil,
    "barbar",
    "buffer_close",
    "Close current buffer"
)
map(
    "n",
    "<C-p>",
    ":BufferPick<CR>",
    nil,
    "barbar",
    "buffer_pick",
    "Pick a buffer"
)
map(
    "n",
    "<leader>bb",
    ":BufferOrderByBufferNumber<CR>",
    nil,
    "barbar",
    "buffer_order_by_number",
    "Order buffers by their numbers"
)
map(
    "n",
    "<leader>bd",
    ":BufferOrderByDirectory<CR>",
    nil,
    "barbar",
    "buffer_order_by_directory",
    "Order buffers by their directories"
)
map(
    "n",
    "<leader>bl",
    ":BufferOrderByLanguage<CR>",
    nil,
    "barbar",
    "buffer_order_by_language",
    "Order buffers by their languages"
)

---------------------------------------------------------
-- nvim-tree
---------------------------------------------------------
map(
    "n",
    "<C-n>",
    ":lua require'tree'.toggle_tree()<CR>",
    { noremap = false },
    "nvim-tree",
    "nvim_tree_toggle",
    "Toggles nvim tree"
)

---------------------------------------------------------
-- telescope
---------------------------------------------------------
map(
    "n",
    "<leader>ff",
    ":lua require'telescope.builtin'.find_files()<CR>",
    nil,
    "telescope",
    "telescope_find_files",
    "Find files in current project"
)
map(
    "n",
    "<leader>fg",
    ":lua require'telescope.builtin'.live_grep()<CR>",
    nil,
    "telescope",
    "telescope_live_grep",
    "Grep for any text in current project"
)
map(
    "n",
    "<leader>fb",
    ":lua require'telescope.builtin'.buffers()<CR>",
    nil,
    "telescope",
    "telescope_buffers",
    "Find an open buffer"
)

---------------------------------------------------------
-- trouble
---------------------------------------------------------
map(
    "n",
    "<leader>xx",
    "<cmd>Trouble<cr>",
    nil,
    "trouble",
    "trouble_preview",
    "Open trouble"
)
map(
    "n",
    "<leader>xw",
    "<cmd>Trouble workspace_diagnostics<cr>",
    nil,
    "trouble",
    "trouble_workspace_diagnostics",
    "Open trouble workspace diagnostics"
)
map(
    "n",
    "<leader>xd",
    "<cmd>Trouble document_diagnostics<cr>",
    nil,
    "trouble",
    "trouble_document_diagnostics",
    "Open trouble document diagnostics"
)
map(
    "n",
    "<leader>xl",
    "<cmd>Trouble loclist<cr>",
    nil,
    "trouble",
    "trouble_loclist",
    "Open trouble loclist(window local)"
)
map(
    "n",
    "<leader>qf",
    "<cmd>Trouble quickfix<cr>",
    nil,
    "trouble",
    "trouble_quickfix",
    "Open trouble quickfix(nvim global)"
)

---------------------------------------------------------
-- nvim-cmp
---------------------------------------------------------
map(
    "i",
    "<C-p>",
    "cmp.mapping.select_prev_item()",
    nil,
    "nvim-cmp",
    "cmp.mapping.select_prev_item()",
    "Select previous item on nvim-cmp suggestion list",
    true
)
map(
    "i",
    "<C-n>",
    "cmp.mapping.select_next_item()",
    nil,
    "nvim-cmp",
    "cmp.mapping.select_next_item()",
    "Select next item on nvim-cmp suggestion list",
    true
)
map(
    "i",
    "<C-d>",
    "cmp.mapping.scroll_docs(-4)",
    nil,
    "nvim-cmp",
    "cmp.mapping.scroll_docs(-4)",
    "Scroll down on nvim-cmp docs list",
    true
)
map(
    "i",
    "<C-f>",
    "cmp.mapping.scroll_docs(4)",
    nil,
    "nvim-cmp",
    "cmp.mapping.scroll_docs(4)",
    "Scroll up on nvim-cmp docs list",
    true
)
map(
    "i",
    "<C-space>",
    "cmp.mapping.complete()",
    nil,
    "nvim-cmp",
    "cmp.mapping.complete()",
    "Show auto-complete suggestions",
    true
)
map(
    "i",
    "<S-Tab>",
    "cmp.mapping.select_prev_item()|luasninp.jump(-1)",
    nil,
    "nvim-cmp",
    "cmp.mapping.select_prev_item()|luasninp.jump(-1)",
    "Select previous item on nvim-cmp suggestion list or jump to the last luasnip position if available",
    true
)
map(
    "i",
    "<Tab>",
    "cmp.mapping.select_next_item()|luasninp.expand_or_jumpable()",
    nil,
    "nvim-cmp",
    "cmp.mapping.select_next_item()|luasninp.expand_or_jumpable()",
    "Select next item on nvim-cmp suggestion list or jump/expand to the next luasnip position if available",
    true
)

---------------------------------------------------------
-- treesitter
---------------------------------------------------------
map(
    "n",
    "gnn",
    "init_selection",
    nil,
    "treesitter",
    "treesitter.init_selection",
    "Start scoped selection with treesitter",
    true
)
map(
    "n",
    "grn",
    "node_incremental",
    nil,
    "treesitter",
    "treesitter.node_incremental",
    "Expand selection with treesitter incrementally by node",
    true
)
map(
    "n",
    "grc",
    "scope_incremental",
    nil,
    "treesitter",
    "treesitter.scope_incremental",
    "Expand selection with treesitter incrementally by scope",
    true
)
map(
    "n",
    "grm",
    "node_decremental",
    nil,
    "treesitter",
    "treesitter.node_decremental",
    "Shrink selection with treesitter decrementally by node",
    true
)
