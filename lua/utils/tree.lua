local nvim_tree_api = require("nvim-tree.api").tree
local nvim_tree_view = safe_require("nvim-tree.view")

local M = {}

function M.is_buffer_nvim_tree(bufnr)
  local currentBuffer = string.lower(vim.api.nvim_buf_get_name(bufnr))
  return string.find(currentBuffer, "nvimtree")
end

function M.focusOrToggleIfFocused()
  local isNvimTreeFocused = M.is_buffer_nvim_tree(0)

  if nvim_tree_view.is_visible() then
    if isNvimTreeFocused then
      vim.cmd("silent! NvimTreeToggle")
    else
      nvim_tree_api.focus()
    end
  else
    vim.cmd("silent! NvimTreeToggle")
  end
end

return M
