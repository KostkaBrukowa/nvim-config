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

  -- File explorer
  use("nvim-tree/nvim-web-devicons")
  use("nvim-tree/nvim-tree.lua")

  -- Buffer and status lines
  use("nvim-lualine/lualine.nvim")

  -- Treesitter
  use("nvim-treesitter/nvim-treesitter")
  use("nvim-treesitter/nvim-treesitter-context")

  -- Keymaps
  use("folke/which-key.nvim")

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use("nvim-telescope/telescope-project.nvim")
  use("windwp/nvim-spectre")

  -- Session management
  use("rmagatti/auto-session")

  -- CMP
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-nvim-lsp")
  use("windwp/nvim-autopairs")
  use("windwp/nvim-ts-autotag")

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
  use("ethanholz/nvim-lastplace")
  use("akinsho/toggleterm.nvim")
  use("gbprod/substitute.nvim")
  use("kylechui/nvim-surround")
  use("anuvyklack/hydra.nvim")
  use("stevearc/stickybuf.nvim")
  use("vuki656/package-info.nvim")
  use("mbbill/undotree")
  use("rareitems/printer.nvim")
  use("AckslD/messages.nvim")
  use("anuvyklack/keymap-amend.nvim")
  use("rgroli/other.nvim")
  use("bronson/vim-visual-star-search")
  use("runiq/neovim-throttle-debounce")
  use("zbirenbaum/copilot.lua")
  use("kevinhwang91/nvim-bqf")
  use("dmmulroy/tsc.nvim")
  use("gbprod/yanky.nvim")
  use("KostkaBrukowa/nvim-cursorword") -- fork of xiyaowong/nvim-cursorword with treesitter support
  use("David-Kunz/gen.nvim")
  use("backdround/improved-search.nvim")
  use("KostkaBrukowa/definition-or-references.nvim")

  use("echasnovski/mini.ai")
  use("echasnovski/mini.bufremove")

  -- UI
  use("stevearc/dressing.nvim")
  use("MunifTanjim/nui.nvim")

  -- LSP
  use("neovim/nvim-lspconfig")
  use({ "VonHeikemen/lsp-zero.nvim", tag = "v2.*" })
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("WhoIsSethDaniel/mason-tool-installer.nvim")
  use("jayp0521/mason-null-ls.nvim")
  use("jose-elias-alvarez/null-ls.nvim")
  use("folke/neodev.nvim")
  use("antosha417/nvim-lsp-file-operations")
  use("j-hui/fidget.nvim")
  use("b0o/schemastore.nvim")
  use({ "git@github.com:allegro-internal/vscode-allegro-metrum" })
  use("pmizio/typescript-tools.nvim")
  use("KostkaBrukowa/clear-action.nvim")

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
  use({
    "mfussenegger/nvim-dap",
    requires = {
      "Pocco81/dap-buddy.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      {
        "microsoft/vscode-js-debug",
        run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
      },
      "mxsdev/nvim-dap-vscode-js",
      "jbyuki/one-small-step-for-vimkind",
    },
  })

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
