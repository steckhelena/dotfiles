return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "oxfmt", "prettier", stop_after_first = true },
      typescript = { "oxfmt", "prettier", stop_after_first = true },
      javascriptreact = { "oxfmt", "prettier", stop_after_first = true },
      typescriptreact = { "oxfmt", "prettier", stop_after_first = true },
    },
    formatters = {
      oxfmt = {
        -- Only use oxfmt when a project marker exists
        condition = function(self, ctx)
          return vim.fs.find({ ".oxfmtrc", ".oxfmtrc.json", ".oxfmtrc.jsonc" }, { upward = true, path = ctx.dirname })[1]
            ~= nil
        end,
      },
    },
  },
}
