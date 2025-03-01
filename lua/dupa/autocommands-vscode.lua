local function enter_normal_mode()
  require("vscode").call("vscode-neovim.escape")
  -- vim.defer_fn(function()
  -- end, 200)
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  callback = enter_normal_mode,
})
