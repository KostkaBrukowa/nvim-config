return {
  "Saghen/blink.cmp",
  enabled = false,
  dependencies = {
    "L3MON4D3/LuaSnip",
  },
  tag = "v0.8.1",
  opts = {
    keymap = {
      preset = "default",
      ["<C-space>"] = { "show", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          elseif require("blink.cmp.completion.windows.menu").win:is_open() then
            return cmp.select_next()
          else
          end
        end,
        "snippet_forward",
        "fallback",
      },

      ["<C-e>"] = { "scroll_documentation_up", "fallback" },
      ["<C-n>"] = { "scroll_documentation_down", "fallback" },
    },

    completion = {
      menu = {
        border = "rounded",
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },

          components = {
            kind_icon = {
              text = function(ctx)
                if ctx.item.source_name == "Buffer" then
                  return ""
                end

                return ctx.kind_icon .. ctx.icon_gap
              end,
            },
            --
            label_description = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.label_description
              end,
              highlight = "BlinkCmpLabelDescription",
            },
            --
            source_name = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.source_name
              end,
            },
          },
        },
      },
      list = {
        selection = "auto_insert",
      },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
        },
      },
      ghost_text = {
        enabled = false,
      },
    },

    -- fuzzy = {
    --   sorts = { "label", "score", "kind" },
    -- },

    snippets = {
      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,
      jump = function(direction)
        require("luasnip").jump(direction)
      end,
    },
    sources = {
      default = {
        "lsp",
        "path",
        "buffer",
        "luasnip",
      },
      providers = {
        luasnip = {
          name = "Luasnip",
          module = "blink.cmp.sources.luasnip",
          score_offset = -3,
          enabled = function(ctx)
            return ctx ~= nil
              and ctx.trigger.kind ~= vim.lsp.protocol.CompletionTriggerKind.TriggerCharacter
          end,
        },
      },
    },
  },
}
