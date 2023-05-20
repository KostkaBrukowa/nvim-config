require("tokyonight").setup({
  dim_inactive = true,
  on_colors = function(colors)
    colors.hint = colors.dark5
    vim.api.nvim_set_hl(0, "MsgArea", { bg = colors.bg_dark })
  end,
})

vim.cmd([[colorscheme tokyonight-moon]])
