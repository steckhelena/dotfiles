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

    -- This is a tab bar for my buffers
    use {
        "romgrk/barbar.nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            local map = require("utils").map

            -- Move to previous/next
            map("n", "<A-,>", ":BufferPrevious<CR>")
            map("n", "<A-.>", ":BufferNext<CR>")
            -- Re-order to previous/next
            map("n", "<A-<>", ":BufferMovePrevious<CR>")
            map("n", "<A->>", " :BufferMoveNext<CR>")
            -- Goto buffer in position...
            map("n", "<A-1>", ":BufferGoto 1<CR>")
            map("n", "<A-2>", ":BufferGoto 2<CR>")
            map("n", "<A-3>", ":BufferGoto 3<CR>")
            map("n", "<A-4>", ":BufferGoto 4<CR>")
            map("n", "<A-5>", ":BufferGoto 5<CR>")
            map("n", "<A-6>", ":BufferGoto 6<CR>")
            map("n", "<A-7>", ":BufferGoto 7<CR>")
            map("n", "<A-8>", ":BufferGoto 8<CR>")
            map("n", "<A-9>", ":BufferGoto 9<CR>")
            map("n", "<A-0>", ":BufferLast<CR>")
            -- Close buffer
            map("n", "<A-c>", ":BufferClose<CR>")
            map("n", "<leader>d", ":BufferClose<cr>")
            -- Magic buffer-picking mode
            map("n", "<C-p>", ":BufferPick<CR>")
            -- Sort automatically by...
            map("n", "<leader>bb", ":BufferOrderByBufferNumber<CR>")
            map("n", "<leader>bd", ":BufferOrderByDirectory<CR>")
            map("n", "<leader>bl", ":BufferOrderByLanguage<CR>")

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
            local map = require("utils").map

            map(
                "n",
                "<C-n>",
                ":lua require'tree'.toggle_tree()<CR>",
                { noremap = false }
            )

            vim.g.nvim_tree_git_hl = true

            require("nvim-tree").setup {
                open_on_setup = true,
            }
        end,
    }

    -- This plugin allows me to list actions, files and other contexts
    use {
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            local map = require("utils").map

            map(
                "n",
                "<leader>ff",
                ":lua require'telescope.builtin'.find_files()<CR>"
            )
            map(
                "n",
                "<leader>fg",
                ":lua require'telescope.builtin'.live_grep()<CR>"
            )
            map(
                "n",
                "<leader>fb",
                ":lua require'telescope.builtin'.buffers()<CR>"
            )
            map(
                "n",
                "<leader><leader>",
                ":lua require'telescope.builtin'.lsp_workspace_symbols()<CR>"
            )

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
        config = function()
            require("lualine").setup()
        end,
    }

    -- This plugin displays the line indentation for better visualization of
    -- code.
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup {
                show_current_context = true,
                show_current_context_start = true,
                show_end_of_line = true,
                space_char_blank_line = " ",
            }
        end,
    }

    -- These are all plugins used for better syntax highlighting
    use "yuezk/vim-js"
    use "HerringtonDarkholme/yats.vim"
    use "othree/html5.vim"
    use "MaxMEllon/vim-jsx-pretty"
    use "jparise/vim-graphql"
    use "elzr/vim-json"
    use "neoclide/jsonc.vim"
    use "cespare/vim-toml"
    use "evanleck/vim-svelte"

    -- This plugin lets me use beautiful icons
    use "ryanoasis/vim-devicons"

    -- Use nvim-lsp as language server client
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"

    -- Lua lsp
    use "folke/lua-dev.nvim"

    -- Use null-ls for more lsp sources
    use {
        "jose-elias-alvarez/null-ls.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("null-ls").setup {
                sources = {
                    require("null-ls").builtins.formatting.stylua,
                    require("null-ls").builtins.diagnostics.eslint,
                    require("null-ls").builtins.formatting.prettierd,
                },
                on_attach = function(client)
                    if client.resolved_capabilities.document_formatting then
                        vim.cmd [[
                            augroup LspFormatting
                                autocmd! * <buffer>
                                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
                            augroup END
                        ]]
                    end
                end,
            }
        end,
    }

    -- Use nvim-cmp as autocomplete
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local luasnip = require "luasnip"
            local cmp = require "cmp"

            cmp.setup {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
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
            }
        end,
    }
    use "L3MON4D3/LuaSnip"

    -- Use nvim-treesitter for better syntax trees
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "maintained",
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
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
    use { "iamcco/markdown-preview.nvim", run = "cd app & yarn install" }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if Packer_bootstrap then
        require("packer").sync()
    end
end)