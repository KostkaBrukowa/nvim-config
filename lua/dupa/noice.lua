require("noice").setup({
  views = {
    mini = {
      position = {
        col = "100%",
        row = -2,
      },
    },
  },
  lsp = {
    signature = {
      auto_open = {
        enabled = false,
      },
    },
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = false,
    },
  },
  messages = {
    enabled = false,
    view_search = false, -- view for search count messages. Set to `false` to disable
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
  smart_move = {
    enabled = false,
  },
})