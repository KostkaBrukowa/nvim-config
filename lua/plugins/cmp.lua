return {
  "hrsh7th/nvim-cmp",
  enabled = true,
  cond = not vim.g.vscode,

  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    { "David-Kunz/cmp-npm", ft = "json" },
    "windwp/nvim-autopairs",
    "windwp/nvim-ts-autotag",

    -- Snippets
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    local keymap = require("cmp.utils.keymap")
    local feedkeys = require("cmp.utils.feedkeys")
    local compare = require("cmp.config.compare")
    local luasnip = require("luasnip")

    require("cmp-npm").setup({
      ignore = { "rc", "canary", "beta", "next", "alpha", "dev" },
    })
    cmp.setup({
      sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "npm", keyword_length = 4 },
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
            npm = "[NPM]",
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
  end,
}
