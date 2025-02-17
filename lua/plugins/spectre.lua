return {
  "windwp/nvim-spectre",
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
