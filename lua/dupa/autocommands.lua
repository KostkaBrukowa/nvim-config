local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")

-- Stops contiuing comment after 'o'
vim.cmd("autocmd FileType * setlocal formatoptions-=o")
vim.cmd("autocmd FileType toggleterm,NvimTree,fugitive,qf setlocal nospell")
-- vim.cmd("autocmd InsertEnter * CursorWordDisable")
-- vim.cmd("autocmd InsertLeave * CursorWordEnable")

-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   callback = function()
--     vim.api.nvim_command("silent! kitty @ set-tab-title nvim " .. vim.fn.getcwd())
--   end,
-- })

local IMPORTS_QUERY = [[
    ; import
    (import_statement) @import
]]

local files_with_folds_closed = {}

-- assumes that all imports are together at the top of the file
local function close_import_folds_with_ts()
  local current_buf_name = vim.api.nvim_buf_get_name(0)

  if vim.tbl_contains(files_with_folds_closed, current_buf_name) then
    return
  end

  local lang = parsers.get_buf_lang(0)
  local root = ts_utils.get_root_for_position(1, 1, parsers.get_parser(0, lang))

  if not root then
    return
  end

  local exports_query = vim.treesitter.query.parse(lang, IMPORTS_QUERY)

  local first_row = -1
  local last_row = -1
  for _, export_name, _ in exports_query:iter_captures(root, 0, root:start(), root:end_()) do
    local start_row, _, end_row = export_name:range()
    last_row = end_row
    if first_row == -1 then
      first_row = start_row
    end
  end

  if last_row == -1 then
    return
  end

  -- delete fold there if previous was here
  local range = first_row .. "," .. last_row + 1
  pcall(vim.cmd, range .. "normal! zD")
  -- close fold
  vim.cmd(range .. "fold")

  table.insert(files_with_folds_closed, current_buf_name)
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.tsx", "*.ts" },
  callback = close_import_folds_with_ts,
})
