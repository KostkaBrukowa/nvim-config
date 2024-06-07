require("tokyonight").setup({
  dim_inactive = true,
  on_colors = function(colors)
    colors.hint = colors.dark5
  end,
  on_highlights = function(highlights, colors)
    highlights["CursorWord"] = { bg = highlights.MiniCursorword.bg }

    highlights["MsgArea"] = { bg = colors.bg_dark }
    highlights["NvimTreeGitUntracked"] = { fg = colors.bg_dark }
    highlights["CurSearch"] = { bg = colors.bg_dark }
    highlights["Search"] = { bg = colors.fg_gutter }

    highlights["SpellBad"] = { sp = colors.hint, undercurl = true }
    highlights["SpellCap"] = { sp = colors.hint, undercurl = true }
    highlights["SpellLocal"] = { sp = colors.hint, undercurl = true }
    highlights["SpellRare"] = { sp = colors.hint, undercurl = true }

    highlights["DiagnosticUnderlineError"] = { sp = "#c53b53", undercurl = true }
    highlights["DiagnosticUnderlineHint"] = { sp = "#4fd6be", undercurl = true }
    highlights["DiagnosticUnderlineInfo"] = { sp = "#0db9d7", undercurl = true }
    highlights["DiagnosticUnderlineWarn"] = { sp = "#ffc777", undercurl = true }

    highlights["GitGutterChange"] = { fg = "" }
    highlights["NeoTreeGitModified"] = { fg = "#7f88b4" }
    highlights["NeoTreeDotFile"] = { fg = "#7f88b4" }
    highlights["WinSeparator"] = { fg = "#444444" }

    highlights.Include = { fg = colors.purple, }
    highlights.Label = { fg = colors.red, }
    highlights["@tag.tsx"] = { fg = colors.blue1, }
    highlights["@tag.delimiter.tsx"] = { fg = colors.dark3, }
    highlights["Function"] = { fg = colors.blue, }
    highlights["CmpItemKindVariable"] = { fg = colors.orange, }
    highlights["LspKindFile"] = { fg = colors.magenta2, }
  end,
})

vim.cmd([[colorscheme tokyonight-moon]])
