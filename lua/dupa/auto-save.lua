local function save()
  vim.schedule(function()
    vim.cmd("silent! wall")
  end)
end

vim.api.nvim_create_autocmd({ "FocusLost" }, {
  callback = save,
  pattern = "*",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = save,
  pattern = { "term://*", "fugitive://*", "Neotest summary" },
})
