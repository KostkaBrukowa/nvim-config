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
    autocmd BufWritePost plugins.lua source <afile> 
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
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("levouh/tint.nvim")
	use("MunifTanjim/nui.nvim")
	use("folke/noice.nvim")

	-- File explorer
	use("nvim-tree/nvim-web-devicons")
	use("nvim-tree/nvim-tree.lua")
	use("nvim-neo-tree/neo-tree.nvim")

	-- Buffer and status lines
	use("nvim-lualine/lualine.nvim")

	-- Treesitter
	use("nvim-treesitter/nvim-treesitter")
	use("windwp/nvim-ts-autotag")
	use("nvim-treesitter/playground")

	-- Keymaps
	use("folke/which-key.nvim")

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("windwp/nvim-spectre")
	use("rgroli/other.nvim")
	use("nvim-telescope/telescope-project.nvim")

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
	use({ "git@github.com:allegro-internal/vscode-allegro-metrum", branch = "neovim" })

	-- Snippets
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")

	-- Comments
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Git
	use("sindrets/diffview.nvim")
	use("tpope/vim-fugitive")
	use("ruifm/gitlinker.nvim")
	use("lewis6991/gitsigns.nvim")

	-- Utils
	use("lewis6991/impatient.nvim")
	use("goolord/alpha-nvim")
	use("ggandor/leap.nvim")
	use("ThePrimeagen/harpoon")
	use("ethanholz/nvim-lastplace")
	use("ellisonleao/glow.nvim")
	use("akinsho/toggleterm.nvim")
	use("rcarriga/nvim-notify")
	use("petertriho/nvim-scrollbar")
	use("gen740/SmoothCursor.nvim")
	use("gbprod/substitute.nvim")
	use("kylechui/nvim-surround")
	use("stevearc/dressing.nvim")
	use("ThePrimeagen/refactoring.nvim")
	use("wellle/targets.vim")
	use("thinca/vim-visualstar") -- Remove after 0.9 nvim
	use("anuvyklack/hydra.nvim")
	use({ "anuvyklack/windows.nvim", requires = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" } })
	use("mrjones2014/smart-splits.nvim")
	use("sindrets/winshift.nvim")
	use("stevearc/stickybuf.nvim")
	use("vuki656/package-info.nvim")
	use("mbbill/undotree")
	use("rareitems/printer.nvim")
	use("AckslD/messages.nvim")

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
	use("MrcJkb/haskell-tools.nvim")

	-- Folding
	use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })
	use({ "stevearc/aerial.nvim" })

	-- Testing
	use({
		"nvim-neotest/neotest",
		wants = {
			"neotest-jest",
		},
		requires = {
			"haydenmeade/neotest-jest",
			"nvim-neotest/neotest-plenary",
		},
	})

	-- Debugging
	use({ "Pocco81/dap-buddy.nvim" })
	use("theHamsta/nvim-dap-virtual-text")
	use("rcarriga/nvim-dap-ui")
	use("mfussenegger/nvim-dap")
	use({
		"microsoft/vscode-js-debug",
		run = "npm install --legacy-peer-deps && npm run compile",
	})
	use("mxsdev/nvim-dap-vscode-js")
	use("jbyuki/one-small-step-for-vimkind")
	use({ "0x100101/lab.nvim", run = "cd js && npm ci" })

	use("stevearc/profile.nvim")

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
