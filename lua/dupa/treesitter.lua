local treesitter = safe_require("nvim-treesitter.configs")

if not treesitter then
  return
end

treesitter.setup({
  ensure_installed = {
    "lua",
    "markdown",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "prisma",
    "json",
    "svelte",
    "scss",
    "c",
    "python",
    "pug",
    "php",
    "java",
    "astro",
    "vue",
    "dockerfile",
    "graphql",
    "haskell",
    "yaml",
    "toml",
  },
  highlight = {
    enable = true,
    disable = function(lang, bufnr) -- Disable in large C++ buffers
      return vim.api.nvim_buf_line_count(bufnr) > 50000
    end,
  },
  rainbow = {
    enable = true,
    extended_mode = false,
  },
  autotag = {
    enable = true,
    enable_close_on_slash = false,
  },
  indent = { enable = true },
})

vim.cmd([[hi rainbowcol1 guifg=#7f849c]])

require("nvim-treesitter.configs").setup({
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      node_decremental = "<S-CR>",
    },
  },
})
