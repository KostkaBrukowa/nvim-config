return {
  -- Essentials
  "wbthomason/packer.nvim",
  "nvim-lua/plenary.nvim",

  -- Colorschemes
  "folke/tokyonight.nvim",

  -- File explorer
  "nvim-tree/nvim-web-devicons",
  "nvim-neo-tree/neo-tree.nvim",

  -- Buffer and status lines
  "nvim-lualine/lualine.nvim",

  -- Treesitter
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-context",

  -- Keymaps
  { "echasnovski/mini.clue", version = "*" },

  -- Telescope
  "KostkaBrukowa/telescope.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "nvim-telescope/telescope-project.nvim",
  {
    "danielfalk/smart-open.nvim",
    dependencies = { "kkharji/sqlite.lua", "nvim-telescope/telescope-fzy-native.nvim" },
  },

  "windwp/nvim-spectre",

  -- CMP
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp",
  { "David-Kunz/cmp-npm", ft = "json" },
  { url = "https://codeberg.org/FelipeLema/cmp-async-path" },
  "windwp/nvim-autopairs",
  "windwp/nvim-ts-autotag",

  -- Snippets
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Comments
  "numToStr/Comment.nvim",
  "JoosepAlviste/nvim-ts-context-commentstring",

  -- Git
  "sindrets/diffview.nvim",
  "tpope/vim-fugitive",
  "ruifm/gitlinker.nvim",
  "lewis6991/gitsigns.nvim",

  -- Utils
  "lewis6991/impatient.nvim",
  "ethanholz/nvim-lastplace",
  "akinsho/toggleterm.nvim",
  "gbprod/substitute.nvim",
  "kylechui/nvim-surround",
  "nvimtools/hydra.nvim",
  "vuki656/package-info.nvim",
  "mbbill/undotree",
  "rareitems/printer.nvim",
  "AckslD/messages.nvim",
  "anuvyklack/keymap-amend.nvim",
  "rgroli/other.nvim",
  "bronson/vim-visual-star-search",
  "runiq/neovim-throttle-debounce",
  -- "zbirenbaum/copilot.lua",
  "github/copilot.vim",
  "kevinhwang91/nvim-bqf",
  "dmmulroy/tsc.nvim",
  "gbprod/yanky.nvim",
  "KostkaBrukowa/nvim-cursorword", -- fork of xiyaowong/nvim-cursorword with treesitter support
  "backdround/improved-search.nvim",
  "KostkaBrukowa/definition-or-references.nvim",
  "johmsalas/text-case.nvim",

  "KostkaBrukowa/mini.ai",
  "echasnovski/mini.bufremove",

  -- UI
  "stevearc/dressing.nvim",
  "MunifTanjim/nui.nvim",

  -- LSP
  "neovim/nvim-lspconfig",
  { "VonHeikemen/lsp-zero.nvim", version = "v3.x" },
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "jayp0521/mason-null-ls.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  "folke/neodev.nvim",
  "antosha417/nvim-lsp-file-operations",
  "j-hui/fidget.nvim",
  "b0o/schemastore.nvim",
  {
    "git@github.com:allegro-internal/vscode-allegro-metrum",
    build = "npm ci --quiet && npm ci --prefix ./server --quiet && npm run build",
  },
  "pmizio/typescript-tools.nvim",
  "KostkaBrukowa/clear-action.nvim",
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    config = function()
      require("tiny-inline-diagnostic").setup({
        options = {
          show_source = true,
        },
        hi = {
          background = "",
        },
        signs = {
          left = "",
          right = "",
          arrow = "   ",
        },
      })
    end,
  },
  "folke/neoconf.nvim",

  -- Folding
  { "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },

  -- Testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "thenbe/neotest-playwright",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-jest",
    },
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "Pocco81/dap-buddy.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      {
        "microsoft/vscode-js-debug",
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
      },
      "mxsdev/nvim-dap-vscode-js",
      "jbyuki/one-small-step-for-vimkind",
    },
  },
}
