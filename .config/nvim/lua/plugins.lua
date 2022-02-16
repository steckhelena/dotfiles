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

	-- This substitutes the standard vim directory browser with a better and more
	-- responsive alternative. I also binded it to toggle with <C-n> for faster browsing.
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
	use("nvim-lualine/lualine.nvim")

	-- This plugin displays the line indentation for better visualization of code.
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
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("saadparwaiz1/cmp_luasnip")
	use("L3MON4D3/LuaSnip")
	use("hrsh7th/cmp-path")

	-- Use nvim-treesitter for better syntax trees
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	-- This adds a preview server to nvim for markdown files
	use({ "iamcco/markdown-preview.nvim", run = "cd app & yarn install" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if Packer_bootstrap then
		require("packer").sync()
	end
end)
