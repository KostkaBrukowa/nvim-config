local cmp_action = require("lsp-zero").cmp_action()
local lspkind = require("lspkind")
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
  "html",
  "cssls",
  "yamlls",
  "marksman",
})

lsp.format_on_save({
  format_opts = {
    timeout_ms = 10000,
  },
  servers = {
    ["null-ls"] = { "javascript", "typescript", "lua", "javascriptreact", "typescriptreact" },
  },
})

lsp.nvim_workspace()

local null_ls = require("null-ls")
local null_opts = lsp.build_options("null-ls", {})

null_ls.setup({
  on_attach = function(client, bufnr)
    null_opts.on_attach(client, bufnr)
  end,
})

require("mason-null-ls").setup({
  ensure_installed = nil,
  automatic_installation = false, -- You can still set this to `true`
  handlers = {
    prettierd = function()
      null_ls.register(null_ls.builtins.formatting.prettierd.with({
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
  show = require("dupa.lsp.convert-multiline-diagnostics-to-singleline").remove_multiline_underline_handler,
  hide = vim.diagnostic.handlers.underline.hide,
}

vim.diagnostic.handlers.virtual_text = {
  show = require("dupa.lsp.convert-multiline-diagnostics-to-singleline").add_source_to_virtual_text_handler,
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
  -- formatting = {
  --   fields = { "kind", "abbr", "menu" },
  --   format = lspkind.cmp_format({
  --     mode = "symbol",
  --     maxwidth = 50,
  --     before = function(entry, vim_item)
  --       vim_item.menu = ({
  --         nvim_lsp = "[LSP]",
  --         luasnip = "[Snippet]",
  --         buffer = "",
  --         path = "[Path]",
  --       })[entry.source.name]
  --
  --       vim_item.kind = ({
  --         nvim_lsp = vim_item.kind,
  --         luasnip = vim_item.kind,
  --         buffer = "",
  --         path = vim_item.kind,
  --       })[entry.source.name]
  --
  --       if entry.source.name == "nvim_lsp" then
  --         local menu
  --         if entry:get_completion_item().detail then
  --           menu = entry:get_completion_item().detail
  --         elseif entry.completion_item.label.detail then
  --           menu = entry.completion_item.label.detail
  --         elseif entry.completion_item.label.description then
  --           menu = entry.completion_item.label.description
  --         end
  --
  --         if menu then
  --           if menu:find("Auto import from") then
  --             menu = menu:gsub("Auto import from (.*)\n", "")
  --           end
  --
  --           --think about increasing it
  --           if menu:len() > 40 then
  --             menu = menu:sub(1, 40) .. "..."
  --           end
  --
  --           vim_item.menu = menu
  --         end
  --       end
  --
  --       return vim_item
  --     end,
  --   }),
  -- },
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
