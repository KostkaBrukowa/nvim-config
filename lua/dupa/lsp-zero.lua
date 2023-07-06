local cmp_action = require("lsp-zero").cmp_action()
local lsp = require("lsp-zero").preset({
  name = "recommended",
  set_lsp_keymaps = false,
  manage_nvim_cmp = {
    set_basic_mappings = false,
  },
})

lsp.on_attach(function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  require("lsp-inlayhints").on_attach(client, bufnr)
end)

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

lsp.ensure_installed({
  -- Replace these with whatever servers you want to install
  "jsonls",
  -- "html",
  "cssls",
  "yamlls",
  "marksman",
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
    },
  },
})

lsp.nvim_workspace()

local null_ls = require("null-ls")
local null_opts = lsp.build_options("null-ls", {})
local cspell = require("cspell")
local cspell_config = {
  config = {
    find_json = function()
      return vim.fn.stdpath("config") .. "/cspell.json"
    end,
  },
  diagnostics_postprocess = function(diagnostic)
    diagnostic.severity = vim.diagnostic.severity["HINT"]
  end,
}
local sources = {
  cspell.diagnostics.with(cspell_config),
  cspell.code_actions.with(cspell_config),
}

null_ls.setup({
  sources = sources,
  should_attach = function(bufnr)
    return not vim.api.nvim_buf_get_name(bufnr):match("^git://")
      and not vim.api.nvim_buf_get_name(bufnr):match("NvimTree_")
  end,
  on_attach = function(client, bufnr)
    null_opts.on_attach(client, bufnr)
  end,
  diagnostics_postprocess = function(diagnostic)
    print([[[lsp-zero.lua:63] -- diagnostic: ]] .. vim.inspect(diagnostic))
    diagnostic.severity = vim.diagnostic.severity["HINT"]
  end,
})

require("mason-null-ls").setup({
  ensure_installed = nil,
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
          return require("prettier").config_exists({
            check_package_json = true,
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
  virtual_text = {
    prefix = "  ",
  },
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
local cmp = require("cmp")
local keymap = require("cmp.utils.keymap")
local feedkeys = require("cmp.utils.feedkeys")
local compare = require("cmp.config.compare")

cmp.setup({
  mapping = {
    ["<C-e>"] = cmp.mapping.scroll_docs(-4),
    ["<C-n>"] = cmp.mapping.scroll_docs(4),
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<Tab>"] = {
      i = function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          feedkeys.call(keymap.t("<tab>"), "n")
        end
      end,
    },
    ["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Esc>"] = cmp.mapping({
      i = function()
        cmp.mapping.abort()
        vim.cmd("stopinsert")
      end,
    }),
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
      compare.custom_required,
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

require("lsp-inlayhints").setup()

-- require("lspconfig").tsserver.setup({
--   settings = {
--     typescript = {
--       inlayHints = {
--         includeInlayParameterNameHints = "all",
--         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--         includeInlayFunctionParameterTypeHints = true,
--         includeInlayVariableTypeHints = true,
--         includeInlayVariableTypeHintsWhenTypeMatchesName = false,
--         includeInlayPropertyDeclarationTypeHints = true,
--         includeInlayFunctionLikeReturnTypeHints = true,
--         includeInlayEnumMemberValueHints = true,
--       },
--     },
--     javascript = {
--       inlayHints = {
--         includeInlayParameterNameHints = "all",
--         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--         includeInlayFunctionParameterTypeHints = true,
--         includeInlayVariableTypeHints = true,
--         includeInlayVariableTypeHintsWhenTypeMatchesName = false,
--         includeInlayPropertyDeclarationTypeHints = true,
--         includeInlayFunctionLikeReturnTypeHints = true,
--         includeInlayEnumMemberValueHints = true,
--       },
--     },
--   },
-- })
