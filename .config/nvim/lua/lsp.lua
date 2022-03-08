local map = require("utils").map

vim.diagnostic.config {
    virtual_text = false,
    signs = true,
    underline = false,
    update_in_insert = false,
    severity_sort = false,
}
map("n", "<leader>e", "<cmd>Lspsaga show_line_diagnostics<cr>")
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local servers = {
    "pyright",
    "clangd",
    "tsserver",
    "sumneko_lua",
    "jsonls",
    "yamlls",
    "tflint",
    "ltex",
    "taplo",
    "terraformls",
    "svelte",
}
local lsp_installer_servers = require "nvim-lsp-installer.servers"

local null_ls_formatting_override = { tsserver = true }

local lsp_status = require "lsp-status"
lsp_status.register_progress()
capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)

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
        map("n", "K", "<cmd>Lspsaga hover_doc<cr>", { buffer = true })
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
        map("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", { buffer = true })
    end

    if client.resolved_capabilities.code_action then
        map(
            "n",
            "<leader>ca",
            "<cmd>Lspsaga code_action<cr>",
            { buffer = true }
        )
        map(
            "x",
            "<leader>ca",
            ":<c-u>Lspsaga range_code_action<cr>",
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

            if server_name == "jsonls" then
                extra_opts = {
                    settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                        },
                    },
                }
            end

            opts = vim.tbl_deep_extend("error", opts, extra_opts)

            server:setup(opts)
        end)

        if not server:is_installed() then
            server:install()
        end
    end
end
