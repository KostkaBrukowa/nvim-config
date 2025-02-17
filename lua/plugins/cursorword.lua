return {
  "KostkaBrukowa/nvim-cursorword",
  config = function()
    vim.cmd("let g:cursorword_disable_filetypes = ['fugitive', 'NvimTree']")
    vim.cmd("let g:cursorword_disable_at_startup = v:false")
  end,
}
