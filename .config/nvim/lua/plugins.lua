local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    Packer_bootstrap = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    -- This colors html color codes
    use({
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    })

    -- This enables using git commands from nvim
    use("tpope/vim-fugitive")

    -- This enables me using gcc to comment out a line or gc with a motion or
    -- in visual mode.
    use("tpope/vim-commentary")

    use("kyazdani42/nvim-web-devicons")

    -- This is a tab bar for my buffers
    use("romgrk/barbar.nvim")

    -- This plugin automatically closes brackets after pressing return
    use("cohama/lexima.vim")

    -- This plugin automatically closes tags
    use("alvan/vim-closetag")

    -- This plugin automatically adjusts indent options based on file type
    use("tpope/vim-sleuth")

    -- This substitutes the standard vim directory browser with a better and
    -- more responsive alternative. I also binded it to toggle with <C-n>
    -- for faster browsing.
    use("scrooloose/nerdtree")

    -- This plugin shows git status on nerdtree
    use("Xuyuanp/nerdtree-git-plugin")

    -- This plugin allows me to use fzf, Ag or ripgrep to grep inside files
    use({
        "junegunn/fzf",
        run = function()
            vim.fn["fzf#install"]()
        end,
    })
    use("junegunn/fzf.vim")

    -- This changes automatically the root dir to the file I am working on
    use("airblade/vim-rooter")

    -- This gives me those sexy bars under my screen with all kinds of info.
    use({
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup()
        end,
    })

    -- This plugin displays the line indentation for better visualization of
    -- code.
    use("lukas-reineke/indent-blankline.nvim")

    -- These are all plugins used for better syntax highlighting
    use("yuezk/vim-js")
    use("HerringtonDarkholme/yats.vim")
    use("othree/html5.vim")
    use("MaxMEllon/vim-jsx-pretty")
    use("jparise/vim-graphql")
    use("elzr/vim-json")
    use("neoclide/jsonc.vim")
    use("cespare/vim-toml")
    use("evanleck/vim-svelte")

    -- This plugin lets me use beautiful icons
    use("ryanoasis/vim-devicons")

    -- Use nvim-lsp as language server client
    use("neovim/nvim-lspconfig")
    use("williamboman/nvim-lsp-installer")

    -- Lua lsp
    use("folke/lua-dev.nvim")

    -- Use nvim-cmp as autocomplete
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local luasnip = require("luasnip")
            local cmp = require("cmp")

            cmp.setup({
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
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
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
            })
        end,
    })
    use("L3MON4D3/LuaSnip")

    -- Use nvim-treesitter for better syntax trees
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
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
            })
        end,
    })

    -- This adds a preview server to nvim for markdown files
    use({ "iamcco/markdown-preview.nvim", run = "cd app & yarn install" })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if Packer_bootstrap then
        require("packer").sync()
    end
end)
