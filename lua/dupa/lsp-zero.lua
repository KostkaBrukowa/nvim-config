local lsp = require("lsp-zero")

lsp.extend_lspconfig({
  -- capabilities = require("cmp_nvim_lsp").default_capabilities(),
  float_border = "rounded",
  sign_text = true,
})

lsp.set_server_config({
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
})

lsp.format_on_save({
  format_opts = {
    timeout_ms = 10000,
  },
  servers = {
    ["null-ls"] = {
      "javascript",
      "typescript",
      "lua",
      "javascriptreact",
      "typescriptreact",
      "postcss",
      "json",
      "cs",
      "python",
    },
    ["eslint"] = {
      "javascript",
      "typescript",
      "lua",
      "javascriptreact",
      "typescriptreact",
      "postcss",
      "json",
    },
    ["black"] = {
      "python",
    },
  },
})

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { "jsonls", "html", "cssls", "yamlls", "marksman", "lua_ls" },
  handlers = {
    lsp.default_setup,
  },
})

local null_ls = require("null-ls")

null_ls.setup({
  should_attach = function(bufnr)
    return not vim.api.nvim_buf_get_name(bufnr):match("^git://")
      and not vim.api.nvim_buf_get_name(bufnr):match("NvimTree_")
  end,
})

require("mason-null-ls").setup({
  ensure_installed = {},
  automatic_installation = false, -- You can still set this to `true`
  handlers = {
    prettierd = function()
      null_ls.register(null_ls.builtins.formatting.prettierd.with({
        filetypes = vim.tbl_extend(
          "force",
          null_ls.builtins.formatting.prettierd.filetypes,
          { [#null_ls.builtins.formatting.prettierd.filetypes + 1] = "postcss" }
        ),
        condition = function()
          return require("utils.file").config_exists({
            check_package_json = true,
            config_names = { ".prettierrc*", "prettier.config.*" },
          })
        end,
      }))
    end,
    stylelint = function()
      null_ls.register(null_ls.builtins.formatting.stylelint.with({
        filetypes = vim.tbl_extend(
          "force",
          null_ls.builtins.formatting.stylelint.filetypes,
          { [#null_ls.builtins.formatting.stylelint.filetypes + 1] = "postcss" }
        ),
      }))
      null_ls.register(null_ls.builtins.diagnostics.stylelint.with({
        filetypes = vim.tbl_extend(
          "force",
          null_ls.builtins.formatting.stylelint.filetypes,
          { [#null_ls.builtins.formatting.stylelint.filetypes + 1] = "postcss" }
        ),
      }))
    end,

    stylua = function()
      null_ls.register(null_ls.builtins.formatting.stylua.with({
        condition = function()
          return require("utils.file").config_exists({
            check_package_json = true,
            config_names = { "stylua.*" },
          })
        end,
      }))
    end,
  },
})

lsp.setup()

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  signs = false,
  virtual_text = false,
})

vim.diagnostic.handlers.underline = {
  show = require("dupa.lsp.custom-lsp-handlers").remove_multiline_underline_handler,
  hide = vim.diagnostic.handlers.underline.hide,
}

vim.diagnostic.handlers.virtual_text = {
  show = require("dupa.lsp.custom-lsp-handlers").add_source_to_virtual_text_handler,
  hide = vim.diagnostic.handlers.virtual_text.hide,
}

-- TODO move to separate file
require("lspconfig").jsonls.setup({
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

require("lspconfig").yamlls.setup({
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
})

require("lspconfig").lua_ls.setup({
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})

-- https://www.allegro.pl/404
-- require("lspconfig").tsserver.setup({
--   init_options = {
--     tsserver = {
--       logDirectory = "/Users/jaroslaw.glegola/.config/nvim/",
--       logVerbosity = "requestTime",
--     },
--   },
-- })
