local map = require("utils").map

map("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local servers = { "pyright", "clangd", "tsserver", "sumneko_lua" }
local lsp_installer_servers = require "nvim-lsp-installer.servers"

local null_ls_formatting_override = { tsserver = true }

local lsp_status = require "lsp-status"
lsp_status.register_progress()
vim.tbl_extend("keep", capabilities, lsp_status.capabilities)

local on_attach = function(client)
    if client.resolved_capabilities.goto_definition then
        map(
            "n",
            "gd",
            "<cmd>lua require'telescope.builtin'.lsp_definitions()<CR>",
            { buffer = true }
        )
    end

    if client.resolved_capabilities.declaration then
        map(
            "n",
            "gD",
            "<cmd>lua vim.lsp.buf.declaration()<CR>",
            { buffer = true }
        )
    end

    if client.resolved_capabilities.hover then
        map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
    end

    if client.resolved_capabilities.implementation then
        map(
            "n",
            "gi",
            "<cmd>lua require'telescope.builtin'.lsp_implementations()<CR>",
            { buffer = true }
        )
    end

    if client.resolved_capabilities.signature_help then
        map(
            "n",
            "<C-k>",
            "<cmd>lua vim.lsp.buf.signature_help()<CR>",
            { buffer = true }
        )
    end

    if client.resolved_capabilities.workspace_symbol then
        map(
            "n",
            "<leader>wa",
            "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
            { buffer = true }
        )
        map(
            "n",
            "<leader>wr",
            "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
            { buffer = true }
        )
        map(
            "n",
            "<leader>wl",
            "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
            { buffer = true }
        )
        map(
            "n",
            "<leader><leader>",
            ":lua require'telescope.builtin'.lsp_workspace_symbols()<CR>"
        )
    end

    if client.resolved_capabilities.type_definition then
        map(
            "n",
            "<leader>D",
            "<cmd>lua require'telescope.builtin'.lsp_type_definitions()<CR>",
            { buffer = true }
        )
    end

    if client.resolved_capabilities.rename then
        map(
            "n",
            "<leader>rn",
            "<cmd>lua vim.lsp.buf.rename()<CR>",
            { buffer = true }
        )
    end

    if client.resolved_capabilities.code_action then
        map(
            "n",
            "<leader>ca",
            "<cmd>lua require'telescope.builtin'.lsp_code_actions()<CR>",
            { buffer = true }
        )
    end

    if client.resolved_capabilities.find_references then
        map(
            "n",
            "gr",
            "<cmd>lua require'telescope.builtin'.lsp_references()<CR>",
            { buffer = true }
        )
    end

    if client.resolved_capabilities.document_formatting then
        map(
            "n",
            "<leader>f",
            "<cmd>lua vim.lsp.buf.formatting()<CR>",
            { buffer = true }
        )

        if null_ls_formatting_override[client.name] then
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
        end
    end

    require("lsp-status").on_attach(client)
end

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
                opts = require("lua-dev").setup { lspconfig = opts }
            end

            if server_name == "clangd" then
                extra_opts = {
                    handlers = lsp_status.extensions.clangd.setup(),
                    init_options = {
                        clangdFileStatus = true,
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
