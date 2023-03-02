local M = {}

local lsp_formatting = function()
    vim.lsp.buf.format { async = false }
end

local null_ls_formatting_override = {
    tsserver = true,
    jsonls = true,
    lua_ls = true,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
        if not null_ls_formatting_override[client.name] then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    lsp_formatting()
                end,
            })
        else
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end
    end

    if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "gotmpl" then
        vim.diagnostic.disable(bufnr)
        if client.name == "yamlls" then
            client.stop()
        end
    end

    require("lsp-status").on_attach(client)
end

return M
