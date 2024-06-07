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
      return vim.api.nvim_buf_line_count(bufnr) > 10000
    end,
  },
})

require("nvim-treesitter.configs").setup({
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-1>",
      node_incremental = "<C-1>",
      node_decremental = "<S-C-1>",
    },
  },
})

require("nvim-ts-autotag").setup({
  opts = {
    -- Defaults
    enable_close_on_slash = true,
  },
})

local autotag_group = vim.api.nvim_create_augroup("autotag_group_custom", {})

-- rename tags on paste also
vim.api.nvim_create_autocmd({ "User" }, {
  group = autotag_group,
  pattern = { "PastePost" },
  callback = function()
    if require("nvim-ts-autotag.config.plugin").get_opts(vim.bo.filetype).enable_rename then
      require("nvim-ts-autotag.internal").rename_tag()
    end
  end,
})
