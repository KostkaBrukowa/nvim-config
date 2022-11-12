local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
local packer = require("packer")

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	-- Essentials
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")

	-- Colorschemes
	use("folke/tokyonight.nvim")
	use("levouh/tint.nvim")
	use("rktjmp/lush.nvim")
	use("doums/darcula")

	-- File explorer
	use("kyazdani42/nvim-web-devicons")
	use("kyazdani42/nvim-tree.lua")
	use("elihunter173/dirbuf.nvim")

	-- Buffer and status lines
	use("nvim-lualine/lualine.nvim")

	-- Treesitter
	use("nvim-treesitter/nvim-treesitter")
	use("windwp/nvim-ts-autotag")
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("nvim-treesitter/playground")
	use("theHamsta/nvim-semantic-tokens")

	use("folke/which-key.nvim")

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("nvim-telescope/telescope-project.nvim")
	use("windwp/nvim-spectre")

	-- Session management
	use("rmagatti/auto-session")
	use("pocco81/auto-save.nvim")

	-- CMP
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp")
	use("windwp/nvim-autopairs")
	use("onsails/lspkind.nvim")

	-- Snippets
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	use("saadparwaiz1/cmp_luasnip")

	-- Comments
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Git
	use("sindrets/diffview.nvim")
	use("tpope/vim-fugitive")
	use({ "ruifm/gitlinker.nvim", requires = "nvim-lua/plenary.nvim" })

	use({ "lewis6991/gitsigns.nvim" })

	-- Utils
	use("lewis6991/impatient.nvim")
	use("goolord/alpha-nvim")
	use("ggandor/leap.nvim")
	use("ThePrimeagen/harpoon")

	use("lukas-reineke/indent-blankline.nvim")
	use("ethanholz/nvim-lastplace")
	use("abecodes/tabout.nvim")
	use("ellisonleao/glow.nvim")
	use("famiu/bufdelete.nvim")
	use({
		"sitiom/nvim-numbertoggle",
		config = function()
			require("numbertoggle").setup()
		end,
	})
	use("Pocco81/true-zen.nvim")
	use("akinsho/toggleterm.nvim")
	use("rcarriga/nvim-notify")
	use("petertriho/nvim-scrollbar")
	use("inkarkat/vim-ReplaceWithRegister")
	use({
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup()
		end,
	})
	use("stevearc/dressing.nvim")

	-- LSP
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")
	use("lukas-reineke/lsp-format.nvim")
	use({ "glepnir/lspsaga.nvim", branch = "main" })
	use("b0o/schemastore.nvim")
	use("jose-elias-alvarez/typescript.nvim")
	use("jayp0521/mason-null-ls.nvim")
	use("WhoIsSethDaniel/mason-tool-installer.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("ray-x/lsp_signature.nvim")

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
