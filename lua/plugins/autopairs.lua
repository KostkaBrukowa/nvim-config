return {
  "windwp/nvim-autopairs",
  opts = { check_ts = true },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)
    local ok, cmp = pcall(require, "cmp")

    if ok then
      cmp.event:on(
        "confirm_done",
        require("nvim-autopairs.completion.cmp").on_confirm_done({ map_char = { tex = "" } })
      )
    end
  end,
}
