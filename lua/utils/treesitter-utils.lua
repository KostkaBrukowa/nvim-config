local ts = vim.treesitter
local ts_utils = require("nvim-treesitter.ts_utils")
local parsers = require("nvim-treesitter.parsers")

local M = {}

function M.goto_translation()
  local ft = vim.bo.filetype

  if not string.find(ft, "[java|type]script") then
    return false
  end

  local node = ts_utils.get_node_at_cursor(0)

  while
    node
    and (
      node:type() ~= "call_expression"
      or (
        node:type() == "call_expression"
        and vim.treesitter.get_node_text(node:field("function")[1], 0) ~= "i18n"
      )
    )
  do
    node = node:parent()
  end

  if not node then
    print('There is no "i18n" function under cursor!')
    return false
  end

  local args = node:field("arguments")[1]
  local name = vim.treesitter.get_node_text(args:child(1):child(1), 0)

  if not name then
    vim.notify("Treesitter parse failed")
    return false
  end

  local po_winid = vim.fn.bufwinid(vim.fn.bufnr("src/translations/pl-PL.po"))

  if po_winid == -1 then
    vim.cmd(":vs ./src/translations/pl-PL.po")
  else
    vim.api.nvim_set_current_win(po_winid)
  end

  local translation_found = vim.fn.search('"' .. name .. '"')

  vim.cmd("nohl")

  if translation_found == 0 then
    local handle_select_choice = function(picked_option)
      if picked_option == "Yes" then
        vim.api.nvim_buf_set_lines(
          0,
          -1,
          -1,
          false,
          { " ", 'msgid "' .. name .. '"', 'msgstr "' .. name .. '"' }
        )
      end
    end

    vim.ui.select(
      { "Yes", "No" },
      { prompt = "Create missing translation?", telescope = { initial_mode = "normal" } },
      handle_select_choice
    )
  end

  return true
end

local EXPORT_QUERY = [[
    ; export const Name ...
    (export_statement (declaration (variable_declarator (identifier) @export_name)))

    ; export class Name ...

    (export_statement (declaration (identifier) @export_name))

    ; export default Name;
    (export_statement (identifier) @export_name)
]]

function M.goto_main_export()
  local ft = vim.bo.filetype

  if not string.find(ft, "[java|type]script") then
    return false
  end

  local lang = parsers.get_buf_lang(0)
  local root = ts_utils.get_root_for_position(1, 1, parsers.get_parser(0, lang))

  local exports_query = vim.treesitter.query.parse(lang, EXPORT_QUERY)

  for _, export_name, _ in exports_query:iter_captures(root, 0, root:start(), root:end_()) do
    local start_row, start_column = export_name:range()
    vim.api.nvim_win_set_cursor(0, { start_row + 1, start_column })
    require("definition-or-references").definition_or_references()
    return
  end
end

function M.get_ts_node_at(buf, range)
  local root_lang_tree = parsers.get_parser(buf)
  local nvim_row = range.row - 1
  local nvim_col = range.col - 1

  if not root_lang_tree then
    return
  end

  local root = ts_utils.get_root_for_position(nvim_row, nvim_col, root_lang_tree)

  if not root then
    return
  end

  return root:named_descendant_for_range(nvim_row, nvim_col, nvim_row, nvim_col)
end

return M
