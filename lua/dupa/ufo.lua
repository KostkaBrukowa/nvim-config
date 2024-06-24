vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.api.nvim_set_keymap("n", "zR", '<cmd>lua require("ufo").openAllFolds()<cr>', {})
vim.api.nvim_set_keymap("n", "zM", '<cmd>lua require("ufo").closeAllFolds()<cr>', {})

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" ···  [%d lines]"):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

-- local handler = function(virtText, lnum, endLnum, width, truncate)
--   local newVirtText = {}
--   local targetWidth = width
--   local curWidth = 0
--   for _, chunk in ipairs(virtText) do
--     local chunkText = chunk[1]
--     local chunkWidth = vim.fn.strdisplaywidth(chunkText)
--     if targetWidth > curWidth + chunkWidth then
--       table.insert(newVirtText, chunk)
--     else
--       chunkText = truncate(chunkText, targetWidth - curWidth)
--       local hlGroup = chunk[2]
--       table.insert(newVirtText, { chunkText, hlGroup })
--       chunkWidth = vim.fn.strdisplaywidth(chunkText)
--       break
--     end
--     curWidth = curWidth + chunkWidth
--   end
--
--   local suffix = ("·"):rep(width - curWidth)
--   table.insert(newVirtText, { suffix, "MoreMsg" })
--   return newVirtText
-- end

require("ufo").setup({
  close_fold_kinds = {},
  fold_virt_text_handler = handler,
})
