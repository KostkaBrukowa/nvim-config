-- Possible improvements: instead of using OrganizeImports build imports yourself
-- add support for imports that import variable that are in global scope like 'screen' - no idea how
local keymap_amend = require("keymap-amend")
local typescript_tools = require("typescript-tools.api")
local typescript_tools_constants = require("typescript-tools.protocol.constants")

local log = require("dupa.log-mock")
local path_utils = require("dupa.import_on_paste.path_utils")
local diagnostic = require("dupa.import_on_paste.diagnostics")
local utils = require("dupa.import_on_paste.utils")
local find_imports = require("dupa.import_on_paste.find_imports")
local correct_import_path = require("dupa.import_on_paste.correct_import_path")

local last_yank_filename = nil
local pasted_text_end_position = nil
local cursor_position_after_paste = nil

local save_last_yank_filename = function()
  -- TODO some more sophisticated yank storage
  last_yank_filename = vim.api.nvim_buf_get_name(0)
end

local add_missing_imports = function(diagnostics)
  log.trace("Starting on paste with: " .. vim.inspect(last_yank_filename))

  if not last_yank_filename then
    log.trace("Last yank filename was not found")
    return
  end

  if not diagnostics then
    log.trace("No diagnostics provided")
    vim.notify("No diagnostics returned")
    return
  end

  -- get all diagnostics in file after paste
  local missing_import_diagnostics = diagnostic.get_all_missing_import_diagnostics_from_range(
    pasted_text_end_position,
    cursor_position_after_paste,
    diagnostics
  )

  -- read last_yank_filename file and parse with tree-sitter to find all imports
  local source_bufnr = utils.get_bufnr_from_filename(last_yank_filename)
  local imports_to_add = find_imports.find_missing_imports(source_bufnr, missing_import_diagnostics)

  if #imports_to_add == 0 then
    return
  end

  local source_file_directory = path_utils.get_directory(last_yank_filename)
  local target_file_directory = path_utils.get_directory(vim.api.nvim_buf_get_name(0))

  -- correct relative paths in respect to current buffer
  local corrected_imports = vim.tbl_map(function(import)
    -- some imports are strings because some of them we construct manually
    if type(import) == "string" then
      return import
    end
    -- removing \n because nvim_buf_set_lines does not accept endlines
    return correct_import_path
      .correct_import_path(source_bufnr, import, source_file_directory, target_file_directory)
      :gsub("\n", "")
      :gsub(" React, ", "")
  end, imports_to_add)

  table.insert(imports_to_add, "\n")

  -- add all corrected imports at the top of the file
  vim.api.nvim_buf_set_lines(0, 0, 0, true, corrected_imports)
end

local import_on_paste_group = vim.api.nvim_create_augroup("import_on_paste_group", {})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = import_on_paste_group,
  pattern = { "*.ts", "*.tsx" },
  callback = save_last_yank_filename,
})

vim.api.nvim_create_autocmd({ "User" }, {
  group = import_on_paste_group,
  pattern = { "PastePre" },
  callback = function()
    log.trace("Starting paste")

    pasted_text_end_position = vim.api.nvim_win_get_cursor(0)
  end,
})

vim.api.nvim_create_autocmd({ "User" }, {
  group = import_on_paste_group,
  pattern = { "PastePost" },
  callback = function()
    local current_buffer_filetype = vim.bo.filetype

    if current_buffer_filetype ~= "typescript" and current_buffer_filetype ~= "typescriptreact" then
      return
    end

    local _, register_lines_count = vim.fn.getreg('"'):gsub("\n", "\n")

    cursor_position_after_paste = {
      pasted_text_end_position[1] + register_lines_count + 1,
      pasted_text_end_position[2],
    }

    local pasted_filename = vim.api.nvim_buf_get_name(0)

    typescript_tools.request_diagnostics(function(err, diagnostics)
      log.trace("starting processing import on paste with diagnostics")
      if err then
        vim.notify("diagnostics request failed")
      end

      if vim.api.nvim_buf_get_name(0) == pasted_filename then
        add_missing_imports(diagnostics)
      else
        vim.notify("You've changed file before diagnoostics showed up. importing aborted")
      end
    end)
  end,
})
