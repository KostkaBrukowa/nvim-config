local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local fn = vim.fn

-- Leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("v", "p", '"_dP', opts)

-- Text editing
-- Faster movement to end and beggining of the line
keymap("n", "I", "$", opts)
keymap("n", "H", "^", opts)
keymap("v", "I", "$", opts)
keymap("v", "H", "^", opts)

-- <A-j> join line below, weird coz of other remap
local An = fn.has("macunix") == 1 and "ń" or "<A-n>"
keymap("n", An, "J", opts)

keymap("", "N", "9j", opts)
keymap("", "E", "9k", opts)

keymap("", "n", "j", opts)
keymap("", "e", "k", opts)
keymap("", "j", "e", opts)
keymap("", "J", "E", opts)
vim.keymap.set({ "n", "x", "o" }, "k", require("improved-search").stable_next) -- keymap("", "k", "n", opts)
vim.keymap.set({ "n", "x", "o" }, "K", require("improved-search").stable_previous) -- keymap("", "K", "N", opts)

keymap("n", "Y", "y$", opts)

-- change current word and allow to use . for changing next words
keymap("n", "c*", "*Ncgn", opts)

-- Plugins
-- keymap("n", "<leader>r", "<cmd>lua require('substitute').operator()<cr>", opts)
vim.keymap.set({ "n" }, "p", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "PastePre" })
  vim.cmd("norm! p")
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "PastePost" })
  end)
end)
vim.keymap.set({ "n" }, "P", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "PastePre" })
  vim.cmd("norm! P")
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "PastePost" })
  end)
end)
vim.keymap.set({ "n" }, "<leader>r", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "PastePre" })
  require("substitute").operator()
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "PastePost" })
  end)
end)
vim.keymap.set({ "n" }, "<leader>rr", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "PastePre" })
  require("substitute").line()
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "PastePost" })
  end)
end)

keymap("n", "<leader>rI", "<leader>r$", { noremap = false })

-- Old files
--[[
      local match = tonumber(string.match(buffer, "%s*(%d+)"))
      local time_opened_match = string.match(buffer, "%s*(%d+) seconds?") or string.match(buffer, "%d%d?:%d%d?:%d%d?")
      local open_by_lsp = string.match(buffer, "line 0$")
      if match and not open_by_lsp and time_opened_match then
        table.remove(results, 1)

--]]
keymap(
  "n",
  "<Tab>",
  "<cmd>lua require('telescope.builtin').oldfiles({file_ignore_patterns = {}})<CR>",
  {}
)

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-n>", "<C-w>j", opts)
keymap("n", "<C-e>", "<C-w>k", opts)
keymap("n", "<C-i>", "<C-w>l", opts)
keymap("i", "<C-h>", "<cmd>wincmd h<cr>", opts)
keymap("i", "<C-n>", "<cmd>wincmd j<cr>", opts)
keymap("i", "<C-e>", "<cmd>wincmd k<cr>", opts)
keymap("i", "<C-i>", "<cmd>wincmd l<cr>", opts)

-- Go back and forward defined in setup_listeners.lua
keymap("n", "<C-l>", "<C-o>", opts)
keymap("n", "<C-u>", "<C-i>", opts)

keymap("n", "``", "``zz", opts)

-- mapping to execute in spectre as vim.normal
keymap("n", "|||", "<c-w><c-p>", opts)

-- Stay in indent mode when formatting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "<Backspace>", "<C-^>", opts)

keymap("n", "U", "<c-r>", opts)

keymap("i", "<A-Backspace>", "<ESC>lcb", opts)
keymap("n", "<A-Backspace>", "lcb<ESC>", opts)

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
end, { noremap = true })

vim.keymap.set("n", "<leader>ux", require("substitute.exchange").operator, { noremap = true })
vim.keymap.set("n", "<leader>uxx", require("substitute.exchange").line, { noremap = true })
vim.keymap.set("x", "<leader>ux", require("substitute.exchange").visual, { noremap = true })
vim.keymap.set("n", "<leader>uxc", require("substitute.exchange").cancel, { noremap = true })

vim.keymap.set({ "n", "x", "o" }, "k", require("improved-search").stable_next)
vim.keymap.set({ "n", "x", "o" }, "K", require("improved-search").stable_previous)

vim.keymap.set("n", "<LeftMouse>", function() end)
