local on_attach = require("lsp/helpers").on_attach

vim.diagnostic.config {
    virtual_text = false,
    signs = true,
    underline = false,
    update_in_insert = false,
    severity_sort = false,
}
require("neodev").setup {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {
    "pyright",
    "clangd",
    "tsserver",
    "eslint",
    "sumneko_lua",
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
local lsp_installer_servers = require "nvim-lsp-installer.servers"

local lsp_status = require "lsp-status"
lsp_status.register_progress()
capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)

for _, server_name in pairs(servers) do
    local server_available, server =
        lsp_installer_servers.get_server(server_name)

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
                            group = vim.api.nvim_create_augroup(
                                "eslint-autofix",
                                {}
                            ),
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

            server:setup(opts)
        end)

        if not server:is_installed() then
            server:install()
        end
    end
end
