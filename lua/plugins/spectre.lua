return {
  "windwp/nvim-spectre",
  cond = not vim.g.vscode,

  opts = {
    highlight = {
      ui = "String",
      search = "SpectreReplace",
      replace = "Search",
    },
    replace_engine = {
      ["sed"] = {
        cmd = "sed",
        args = {
          "-i",
          "",
          "-E",
        },
      },
    },
  },
}
