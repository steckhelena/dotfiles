local M = {}

local util = require "vim.lsp.util"

local lsp_formatting = function(client, bufnr)
    local params = util.make_formatting_params {}
    client.request("textDocument/formatting", params, nil, bufnr)
end

local null_ls_formatting_override = {
    tsserver = true,
    jsonls = true,
    sumneko_lua = true,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
        if not null_ls_formatting_override[client.name] then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    lsp_formatting(client, bufnr)
                end,
            })
        else
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
        end
    end

    require("lsp-status").on_attach(client)
end

return M
