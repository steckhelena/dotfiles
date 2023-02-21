local on_attach = require("lsp/helpers").on_attach

vim.diagnostic.config {
    virtual_text = false,
    signs = true,
    underline = false,
    update_in_insert = false,
    severity_sort = false,
}
require("neodev").setup {}
require("mason").setup {}
require("mason-lspconfig").setup {
    automatic_installation = true,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {
    "pyright",
    "clangd",
    "tsserver",
    "eslint",
    "lua_ls",
    "jsonls",
    "yamlls",
    "tflint",
    "ltex",
    "taplo",
    "terraformls",
    "svelte",
    "gopls",
    "kotlin_language_server",
}

local lsp_status = require "lsp-status"
lsp_status.register_progress()
capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)

local eslint_group = vim.api.nvim_create_augroup("eslint-autofix", {})

for _, server_name in pairs(servers) do
    local server = require("lspconfig")[server_name]

    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    local extra_opts = {}

    if server_name == "clangd" then
        extra_opts = {
            handlers = lsp_status.extensions.clangd.setup(),
            init_options = {
                clangdFileStatus = true,
            },
            capabilities = {
                offsetEncoding = { "utf-16" },
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

    if server_name == "eslint" then
        extra_opts = {
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = eslint_group,
                    command = "EslintFixAll",
                    buffer = bufnr,
                })

                on_attach(client, bufnr)
            end,
        }
    end

    if server_name == "ltex" then
        extra_opts = {
            filetypes = {
                "bib",
                "markdown",
                "org",
                "plaintex",
                "rst",
                "rnoweb",
                "tex",
            },
        }
    end

    opts = vim.tbl_deep_extend("force", opts, extra_opts)

    server.setup(opts)
end
