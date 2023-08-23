if vim.g.goneovim then
  return
end

require("no-neck-pain").setup({
  -- debug = true,
  width = 115,
  buffers = {
    right = {
      enabled = false,
    },
  },
  autocmds = {
    enableOnVimEnter = true,
  },
})
