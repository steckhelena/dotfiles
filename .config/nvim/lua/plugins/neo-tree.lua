return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "s1n7ax/nvim-window-picker",
      lazy = true,
      opts = {
        hint = "floating-big-letter",
        filter_rules = {
          bo = {
            filetype = { "NvimTree", "neo-tree", "notify", "dashboard", "LazyVim" },
            -- Exclude specific buffer types
            buftype = { "terminal", "nofile" },
          },
        },
      },
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
      window = {
        mappings = {
          -- I always want to use the window picker
          ["<cr>"] = "open_with_window_picker",
        },
      },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local lsp_file_operations = require("lsp-file-operations")
      lsp_file_operations.setup()

      local lspconfig = require("lspconfig")

      -- Set global defaults for all servers
      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          -- returns configured operations if setup() was already called
          -- or default operations if not
          lsp_file_operations.default_capabilities()
        ),
      })
    end,
  },
}
