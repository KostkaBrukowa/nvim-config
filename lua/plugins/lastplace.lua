return {
  "ethanholz/nvim-lastplace",
  cond = not vim.g.vscode,

  opts = {
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
    lastplace_open_folds = true,
  },
}
