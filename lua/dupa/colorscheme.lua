require("tokyonight").setup({
  dim_inactive = true,
  on_colors = function(colors)
    colors.hint = colors.dark5
    vim.api.nvim_set_hl(0, "MsgArea", { bg = colors.bg_dark })
    vim.api.nvim_set_hl(0, "NvimTreeGitUntracked", { fg = colors.bg_dark })
    vim.api.nvim_set_hl(0, "SpellBad", { sp = colors.hint, undercurl = true })
    vim.api.nvim_set_hl(0, "SpellCap", { sp = colors.hint, undercurl = true })
    vim.api.nvim_set_hl(0, "SpellLocal", { sp = colors.hint, undercurl = true })
    vim.api.nvim_set_hl(0, "SpellRare", { sp = colors.hint, undercurl = true })
  end,
})

vim.cmd([[colorscheme tokyonight-moon]])
