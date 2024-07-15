local cmp_action = require("lsp-zero").cmp_action()
local lsp = require("lsp-zero").preset({
  name = "recommended",
  set_lsp_keymaps = false,
  manage_nvim_cmp = {
    set_basic_mappings = false,
  },
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
local null_opts = lsp.build_options("null-ls", {})

null_ls.setup({
  should_attach = function(bufnr)
    return not vim.api.nvim_buf_get_name(bufnr):match("^git://")
      and not vim.api.nvim_buf_get_name(bufnr):match("NvimTree_")
  end,
  on_attach = function()
    null_opts.on_attach()
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

-- vim.fn.executable()

-- TODO move to separate file
local cmp = require("cmp")
local keymap = require("cmp.utils.keymap")
local feedkeys = require("cmp.utils.feedkeys")
local compare = require("cmp.config.compare")
local luasnip = require("luasnip")

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer", keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
  },

  mapping = {
    ["<C-e>"] = cmp.mapping.scroll_docs(-4),
    ["<C-n>"] = cmp.mapping.scroll_docs(4),
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = {
      i = function()
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          feedkeys.call(keymap.t("<tab>"), "n")
        end
      end,
    },
    ["<S-Tab>"] = {
      i = function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          feedkeys.call(keymap.t("<s-tab>"), "n")
        end
      end,
    },
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Esc>"] = cmp.mapping({
      i = function()
        cmp.mapping.abort()
        vim.cmd("stopinsert")
      end,
    }),
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "",
        path = "[Path]",
      })[entry.source.name]

      if vim_item.kind == "Text" then
        vim_item.kind = ""
      end

      return vim_item
    end,
  },
  window = {
    completion = { -- rounded border; thin-style scrollbar
      border = "rounded",
    },
    documentation = { -- no border; native-style scrollbar
      border = "rounded",
    },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  sorting = {
    priority_weight = 1.0,
    comparators = {
      compare.score,
      compare.locality,
      compare.recently_used,
      compare.offset,
      compare.order,
    },
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

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
