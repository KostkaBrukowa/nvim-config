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
  },
  indent = { enable = true },
})

vim.cmd([[hi rainbowcol1 guifg=#7f849c]])

require("nvim-treesitter.configs").setup({
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- Your custom capture.
        ["ia"] = "@parameter.inner",
        ["aa"] = "@parameter.outer",
        -- Custom @parameter.inner and @parameter.outer
        --[[
            (formal_parameters
              "," @_start .
              (_) @parameter.inner
             (#make-range! "parameter.outer" @_start @parameter.inner))
            (formal_parameters
              . (_) @parameter.inner
              . ","? @_end
             (#make-range! "parameter.outer" @parameter.inner @_end))

            ;; arguments
            (arguments
              "," @_start .
              (_) @parameter.inner
             (#make-range! "parameter.outer" @_start @parameter.inner))
            (arguments
              . (_) @parameter.inner
              . ","? @_end
             (#make-range! "parameter.outer" @parameter.inner @_end))

            ;; object
            (object
              "," @_start .
              (_) @parameter.inner
             (#make-range! "parameter.outer" @_start @parameter.inner))
            (object
              . (_) @parameter.inner
              . ","? @_end
             (#make-range! "parameter.outer" @parameter.inner @_end))

            ;; array
            (array
              "," @_start .
              (_) @parameter.inner
             (#make-range! "parameter.outer" @_start @parameter.inner))
            (array
              . (_) @parameter.inner
              . ","? @_end
             (#make-range! "parameter.outer" @parameter.inner @_end))

            ;; object pattern
            (object_pattern
              "," @_start .
              (_) @parameter.inner
             (#make-range! "parameter.outer" @_start @parameter.inner))
            (object_pattern
              . (_) @parameter.inner
              . ","? @_end
             (#make-range! "parameter.outer" @parameter.inner @_end))
        --]]
      },
    },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      node_decremental = "<S-CR>",
    },
  },
})

-- q: how to do multiline comments in lua?
-- a: like this :D (or with --[[ ]])
