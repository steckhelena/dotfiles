local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    Packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
end

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */plugins.lua source <afile> | PackerCompile
  augroup end
]]

return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    -- This colors html color codes
    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    }

    -- helm template syntax highlighting
    use "towolf/vim-helm"

    -- This enables using git commands from nvim
    use "tpope/vim-fugitive"
    use {
        "lewis6991/gitsigns.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("gitsigns").setup {
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol",
                    delay = 400,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = "\t\t\t<author>, <author_time:%Y-%m-%d> - <summary>",
            }
        end,
    }

    -- This enables me using gcc to comment out a line or gc with a motion or
    -- in visual mode.
    use "tpope/vim-commentary"

    use "kyazdani42/nvim-web-devicons"

    use {
        "lazytanuki/nvim-mapper",
        config = function()
            require("nvim-mapper").setup {}
        end,
        before = "telescope.nvim",
    }

    -- This is a tab bar for my buffers
    use {
        "romgrk/barbar.nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            vim.g.bufferline = {
                auto_hide = false,
            }
        end,
    }

    -- This plugin automatically closes brackets after pressing return
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {
                check_ts = true,
            }

            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            local cmp = require "cmp"

            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done { map_char = { tex = "" } }
            )
        end,
    }

    -- This plugin automatically closes tags
    use "windwp/nvim-ts-autotag"

    -- This plugin automatically adjusts indent options based on file type
    use "tpope/vim-sleuth"

    -- This substitutes the standard vim directory browser with a better and
    -- more responsive alternative. I also binded it to toggle with <C-n>
    -- for faster browsing.
    use {
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons", -- optional, for file icon
        },
        config = function()
            require("tree").setup()

            require("nvim-tree").setup {
                open_on_setup = true,
                renderer = {
                    highlight_git = true,
                },
            }
        end,
    }

    -- This plugin allows me to list actions, files and other contexts
    use {
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("telescope").load_extension "mapper"

            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-h>"] = "which_key",
                        },
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
            }
        end,
    }

    -- This changes automatically the root dir to the file I am working on
    use "airblade/vim-rooter"

    -- This gives me those sexy bars under my screen with all kinds of info.
    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            "nvim-lua/lsp-status.nvim",
            "RRethy/nvim-base16",
        },
        config = function()
            -- This workaround is necessary do disable an error from lualine
            -- showing
            local tmp_colors = vim.g.colors_name
            vim.g.colors_name = nil

            require("lualine").setup {
                sections = {
                    lualine_c = { "filename", "require'lsp-status'.status()" },
                },
            }

            vim.g.colors_name = tmp_colors
        end,
    }

    use "hashivim/vim-terraform"

    -- This plugin displays the line indentation for better visualization of
    -- code.
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup {
                show_current_context = true,
                show_current_context_start = true,
                space_char_blank_line = "",
                char = "",
                context_char = "│",
            }
        end,
    }

    -- This plugin lets me use beautiful icons
    use "ryanoasis/vim-devicons"

    -- Use nvim-lsp as language server client
    use {
        "neovim/nvim-lspconfig",
        tag = "v0.1.3",
    }
    use "williamboman/nvim-lsp-installer"

    -- Lua lsp
    use "folke/neodev.nvim"

    -- Use schemastore for json schemas
    use "b0o/schemastore.nvim"

    -- Use null-ls for more lsp sources
    use {
        "jose-elias-alvarez/null-ls.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local null_ls = require "null-ls"
            null_ls.setup {
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.diagnostics.tsc,
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.diagnostics.pylint,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.diagnostics.mypy,
                },
                on_attach = require("lsp/helpers").on_attach,
            }
        end,
    }

    -- Use trouble for diagnostic messages
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {}
        end,
    }

    use "github/copilot.vim"

    -- Use nvim-cmp as autocomplete
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind-nvim",
        },
        config = function()
            local luasnip = require "luasnip"
            local cmp = require "cmp"
            local lspkind = require "lspkind"

            cmp.setup {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-g>"] = cmp.mapping(function(fallback)
                        vim.api.nvim_feedkeys(
                            vim.fn["copilot#Accept"](
                                vim.api.nvim_replace_termcodes(
                                    "<Tab>",
                                    true,
                                    true,
                                    true
                                )
                            ),
                            "n",
                            true
                        )
                    end),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },
                    ["<Tab>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end,
                    ["<S-Tab>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end,
                },
                sources = {
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                },
                formatting = {
                    format = lspkind.cmp_format(),
                },
            }
        end,
    }
    use {
        "L3MON4D3/LuaSnip",
        requires = { "honza/vim-snippets", "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").load()
            require("luasnip.loaders.from_snipmate").load()
        end,
    }

    -- Use lspsaga for prettier lsp interface
    use {
        "tami5/lspsaga.nvim",
        config = function()
            local saga = require "lspsaga"

            saga.setup {
                use_saga_diagnostic_sign = true,
                use_diagnostic_virtual_text = false,
                code_action_keys = {
                    quit = { "q", "<C-[>" },
                    exec = "<CR>",
                },
                code_action_prompt = {
                    enable = false,
                    virtual_text = false,
                },
            }
        end,
    }

    -- Use nvim-treesitter for better syntax trees
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "all",
                ignore_install = { "phpdoc" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "gitcommit" },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
                indent = {
                    enable = true,
                },
                autotag = {
                    enable = true,
                },
            }

            vim.o.foldlevelstart = 20
            vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
            vim.wo.foldmethod = "expr"
        end,
    }

    -- This adds a preview server to nvim for markdown files
    use {
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install --frozen-lockfile",
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if Packer_bootstrap then
        require("packer").sync()
    end
end)
