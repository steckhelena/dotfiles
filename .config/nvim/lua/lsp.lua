-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap(
    "n",
    "<leader>e",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "[d",
    "<cmd>lua vim.diagnostic.goto_prev()<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "]d",
    "<cmd>lua vim.diagnostic.goto_next()<CR>",
    opts
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gD",
        "<cmd>lua vim.lsp.buf.declaration()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gd",
        "<cmd>lua require'telescope.builtin'.lsp_definitions()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "K",
        "<cmd>lua vim.lsp.buf.hover()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gi",
        "<cmd>lua require'telescope.builtin'.lsp_implementation()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<C-k>",
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>wa",
        "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>wr",
        "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>wl",
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>D",
        "<cmd>lua require'telescope.builtin'.lsp_type_definitions()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>rn",
        "<cmd>lua vim.lsp.buf.rename()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>ca",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gr",
        "<cmd>lua require'telescope.builtin'.lsp_references()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>f",
        "<cmd>lua vim.lsp.buf.formatting()<CR>",
        opts
    )
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "clangd", "tsserver", "sumneko_lua", "efm" }
local lsp_installer_servers = require("nvim-lsp-installer.servers")

-- Loop through the servers listed above and set them up. If a server is
-- not already installed, install it.
for _, server_name in pairs(servers) do
    local server_available, server = lsp_installer_servers.get_server(
        server_name
    )

    if server_available then
        server:on_ready(function()
            local opts = {
                on_attach = on_attach,
                capabilities = capabilities,
                flags = {
                    -- This will be the default in neovim 0.7+
                    debounce_text_changes = 150,
                },
            }

            local extra_opts = {}

            if server_name == "sumneko_lua" then
                opts = require("lua-dev").setup({ lspconfig = opts })
            end

            if server_name == "efm" then
                extra_opts = {
                    init_options = { documentFormatting = true },
                    root_dir = vim.loop.cwd,
                    settings = {
                        rootMarkers = { ".git/" },
                        languages = {
                            lua = { require("efm/stylua") },
                        },
                    },
                }
            end

            for k, v in pairs(extra_opts) do
                opts[k] = v
            end

            server:setup(opts)
        end)

        if not server:is_installed() then
            server:install()
        end
    end
end

