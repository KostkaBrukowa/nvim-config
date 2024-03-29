local debounced_save = require("throttle-debounce").debounce_trailing(function()
  vim.cmd("wall")
end, 150)

local function save()
  -- debounced_save()
  vim.cmd("wall")
end

vim.api.nvim_create_autocmd({ "FocusLost" }, {
  callback = save,
  pattern = "*",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = save,
  pattern = { "term://*", "fugitive://*" },
})
