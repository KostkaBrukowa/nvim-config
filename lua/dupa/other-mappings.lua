local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

vim.keymap.set({ "n", "x", "o" }, "k", require("improved-search").stable_next)
vim.keymap.set({ "n", "x", "o" }, "K", require("improved-search").stable_previous)

local wrap_with_paste_autocmds = function(action)
  return function()
    vim.api.nvim_exec_autocmds("User", { pattern = "PastePre" })
    action()
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("User", { pattern = "PastePost" })
    end)
  end
end

-- Plugins
vim.keymap.set(
  { "n" },
  "p",
  wrap_with_paste_autocmds(function()
    vim.cmd("norm! p")
  end)
)

vim.keymap.set(
  { "n" },
  "P",
  wrap_with_paste_autocmds(function()
    vim.cmd("norm! P")
  end)
)

vim.keymap.set(
  { "n" },
  "<leader>r",
  wrap_with_paste_autocmds(function()
    require("substitute").operator()
  end)
)

vim.keymap.set(
  { "n" },
  "<leader>rr",
  wrap_with_paste_autocmds(function()
    require("substitute").line()
  end)
)

keymap("n", "<leader>rI", "<leader>r$", { noremap = false })

keymap(
  "n",
  "<Tab>",
  "<cmd>lua require('telescope.builtin').oldfiles({file_ignore_patterns = {}})<CR>",
  {}
)

keymap("n", "m", "mm", opts)
vim.keymap.set("n", "<leader>m", function()
  local m_mark = vim.api.nvim_buf_get_mark(0, "m")
  if m_mark[1] == 0 and m_mark[2] == 0 then
    vim.notify("No mark set")
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)

  vim.api.nvim_win_set_cursor(0, m_mark)

  vim.api.nvim_buf_set_mark(0, "m", cursor[1], cursor[2], {})
end, { noremap = true, desc = "Set custom mark" })

vim.keymap.set("n", "<leader>ux", require("substitute.exchange").operator, { noremap = true })
vim.keymap.set("n", "<leader>uxx", require("substitute.exchange").line, { noremap = true })
vim.keymap.set("x", "<leader>ux", require("substitute.exchange").visual, { noremap = true })
vim.keymap.set("n", "<leader>uxc", require("substitute.exchange").cancel, { noremap = true })

vim.keymap.set("n", "<LeftMouse>", function() end)
