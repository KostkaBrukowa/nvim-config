return {
  "KostkaBrukowa/nvim-cursorword",
  cond = not vim.g.vscode,

  config = function()
    vim.cmd("let g:cursorword_disable_filetypes = ['fugitive', 'NvimTree']")
    vim.cmd("let g:cursorword_disable_at_startup = v:false")
  end,
}
