local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "folke/neodev.nvim",
  "folke/which-key.nvim",
  "wbthomason/packer.nvim",
  "nvim-lua/plenary.nvim",

  -- Colorschemes
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd.colorscheme("tokyonight-moon")
    end,
  },
  -- File explorer
  "nvim-tree/nvim-web-devicons",
  { "nvim-tree/nvim-tree.lua" },

  -- Buffer and status lines
  "nvim-lualine/lualine.nvim",

  -- Treesitter
  "nvim-treesitter/nvim-treesitter",
  "windwp/nvim-ts-autotag",
  "nvim-treesitter/nvim-treesitter-context",
  "nvim-treesitter/nvim-treesitter-textobjects",

  -- Keymaps
  "folke/which-key.nvim",

  -- Telescope
  "nvim-telescope/telescope.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "nvim-telescope/telescope-project.nvim",
  { "ibhagwan/fzf-lua" }, -- for faster find files

  -- Session management
  "rmagatti/auto-session",

  -- CMP
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp",
  "windwp/nvim-autopairs",
  "onsails/lspkind.nvim",

  -- Snippets
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Comments
  "numToStr/Comment.nvim",
  "JoosepAlviste/nvim-ts-context-commentstring",

  -- Git
  "tpope/vim-fugitive",
  "ruifm/gitlinker.nvim",
  "lewis6991/gitsigns.nvim",

  -- Utils
  "ethanholz/nvim-lastplace",
  { "ellisonleao/glow.nvim", opts = {} },
  {
    "rcarriga/nvim-notify",
    opts = { timeout = 1000, stages = "fade", top_down = false },
    init = function()
      vim.notify = require("notify")
    end,
  },
  { "gbprod/substitute.nvim", opts = {} },
  { "kylechui/nvim-surround", opts = {} },
  "stevearc/dressing.nvim",
  { "jinh0/eyeliner.nvim", opts = { highlight_on_key = true, dim = true } },
  "mrjones2014/smart-splits.nvim",
  "sindrets/winshift.nvim",
  { "stevearc/stickybuf.nvim", opts = {} },
  "vuki656/package-info.nvim",
  "mbbill/undotree",
  "rareitems/printer.nvim",
  { "AckslD/messages.nvim", opts = {} },
  { "tzachar/local-highlight.nvim", opts = {} },
  "anuvyklack/keymap-amend.nvim",
  "rgroli/other.nvim",
  { "KostkaBrukowa/no-neck-pain.nvim", version = "*" },
  "MunifTanjim/nui.nvim",
  {
    "utilyre/barbecue.nvim",
    dependencies = { "SmiteshP/nvim-navic" },
  },
  "runiq/neovim-throttle-debounce",
  "zbirenbaum/copilot.lua",
  { "davidmh/cspell.nvim", enabled = false },
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
        ["Add Cursor Down"] = "<C-m>",
        ["I"] = "$",
        ["H"] = "^",
      }
      vim.g.VM_default_mappings = 0
      vim.g.VM_custom_motions = { l = "i", I = "$", H = "^" }
    end,
  },

  -- LSP
  { "VonHeikemen/lsp-zero.nvim", version = "v2.*" },
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "b0o/schemastore.nvim",
  "jayp0521/mason-null-ls.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  "MunifTanjim/prettier.nvim",
  "ray-x/lsp_signature.nvim",
  { "dmmulroy/tsc.nvim", opts = {} },

  { dir = "~/Documents/Praca/definition-or-references.nvim" },
  { "antosha417/nvim-lsp-file-operations", opts = { debug = false } },
  { "j-hui/fidget.nvim", opts = {}, enabled = false },
  { "git@github.com:allegro-internal/vscode-allegro-metrum", branch = "neovim", opts = {} },

  -- Folding
  { "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },
  { "stevearc/aerial.nvim" },

  { "kevinhwang91/nvim-bqf", ft = "qf" },

  { { import = "dupa.plugins" } },
})
