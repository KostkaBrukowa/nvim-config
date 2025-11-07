local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")

-- Stops contiuing comment after 'o'
vim.cmd("autocmd FileType * setlocal formatoptions-=o")
vim.cmd("autocmd FileType toggleterm,NvimTree,fugitive,qf setlocal nospell")

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
  for _, export_name, _ in exports_query:iter_captures(root, 0) do
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

vim.api.nvim_create_user_command("Eslint", function()
  vim.cmd("compiler eslint | make ./ | copen")
end, {})

vim.api.nvim_create_user_command("EslintPanel", function()
  vim.cmd(
    "compiler jest | make --selectProjects lint --silent --reporters=jest-silent-reporter | copen"
  )
end, {})

vim.api.nvim_create_user_command("JestPanel", function()
  vim.cmd("compiler jest | make --selectProjects test | copen")
end, {})

vim.api.nvim_create_user_command("Jest", function()
  vim.cmd("compiler jest | make | copen")
end, {})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
  desc = "Highlight references under cursor",
  callback = function()
    -- Only run if the cursor is not in insert mode
    if vim.fn.mode() ~= "i" then
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local supports_highlight = false
      for _, client in ipairs(clients) do
        if client.server_capabilities.documentHighlightProvider then
          supports_highlight = true
          break -- Found a supporting client, no need to check others
        end
      end

      -- 3. Proceed only if an LSP is active AND supports the feature
      if supports_highlight then
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end
    end
  end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMovedI", {
  group = "LspReferenceHighlight",
  desc = "Clear highlights when entering insert mode",
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

-- Kitty padding management
local function set_kitty_padding()
  -- Only proceed if we're running in Kitty
  if vim.env.KITTY_WINDOW_ID == nil or vim.env.KITTY_WINDOW_ID == "" then
    return
  end

  -- Count vertical splits (windows side by side, not stacked)
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local columns = {}

  for _, win in ipairs(wins) do
    -- Check if window is valid and not floating
    if vim.api.nvim_win_is_valid(win) then
      local config = vim.api.nvim_win_get_config(win)
      if config.relative == "" then -- Not a floating window
        -- Get window position (column position)
        local win_pos = vim.api.nvim_win_get_position(win)
        local col = win_pos[2] -- Column (horizontal position)

        -- Track unique column positions (different columns = vertical splits)
        if not vim.tbl_contains(columns, col) then
          table.insert(columns, col)
        end
      end
    end
  end

  -- If more than one column (vertical split), remove padding
  if #columns > 1 then
    vim.fn.system("kitty @ set-spacing padding-left=0 2>/dev/null")
    return
  end

  -- Get window width and calculate 30% padding
  local width = vim.o.columns
  local padding = math.floor(width * 1.9)

  -- Apply padding
  vim.fn.system(string.format("kitty @ set-spacing padding-left=%d 2>/dev/null", padding))
end

-- Create autogroup for Kitty padding
local kitty_group = vim.api.nvim_create_augroup("KittyPadding", { clear = true })

-- Set padding on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  group = kitty_group,
  desc = "Set Kitty padding on Vim enter",
  callback = set_kitty_padding,
})

-- Update padding when window layout changes
vim.api.nvim_create_autocmd({ "WinNew", "WinClosed" }, {
  group = kitty_group,
  desc = "Update Kitty padding on window changes",
  callback = function()
    -- Small delay to ensure window layout is updated
    vim.defer_fn(set_kitty_padding, 150)
  end,
})

-- Remove padding on VimLeave
vim.api.nvim_create_autocmd("VimLeave", {
  group = kitty_group,
  desc = "Remove Kitty padding on Vim exit",
  callback = function()
    if vim.env.KITTY_WINDOW_ID ~= nil and vim.env.KITTY_WINDOW_ID ~= "" then
      vim.fn.system("kitty @ set-spacing padding-left=0 2>/dev/null")
    end
  end,
})
