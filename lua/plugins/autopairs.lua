return {
  "windwp/nvim-autopairs",
  opts = { check_ts = true },
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)
    require("cmp").event:on(
      "confirm_done",
      require("nvim-autopairs.completion.cmp").on_confirm_done({ map_char = { tex = "" } })
    )
  end,
}
