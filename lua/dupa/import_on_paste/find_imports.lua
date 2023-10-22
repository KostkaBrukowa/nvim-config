local log = require("dupa.log-mock")
local utils = require("dupa.import_on_paste.utils")
local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")
local my_ts_utils = require("utils.treesitter-utils")
local M = {}

local IMPORTS_QUERY = [[
    ; import { import_name } from '...'
    (import_statement (import_clause (named_imports (import_specifier (identifier) @import_name))))

    ; import import_name from '...'
    (import_statement (import_clause (identifier) @import_name))

    ; import * as import_name from '...'
    (import_statement (import_clause (namespace_import (identifier) @import_name)))
]]

local EXPORT_QUERY = [[
    ; export const Name ...
    (export_statement (declaration (variable_declarator (identifier) @export_name)))

    ; export class Name ...
    (export_statement (declaration (type_identifier) @export_name))

    ; export default Name;
    (export_statement (identifier) @export_name)
]]

local function find_full_import_statement(node)
  local parent = node:parent()

  while parent ~= nil do
    if parent:type() == "import_statement" then
      return parent
    end

    parent = parent:parent()
  end

  return nil
end

local function find_all_import_export_specifiers_nodes(source_bufnr)
  local lang = parsers.get_buf_lang(source_bufnr)
  local root = ts_utils.get_root_for_position(1, 1, parsers.get_parser(source_bufnr, lang))

  local all_import_names_query = vim.treesitter.query.parse(lang, IMPORTS_QUERY)

  local import_name_nodes = {}
  for _, import_name, _ in
    all_import_names_query:iter_captures(root, source_bufnr, root:start(), root:end_())
  do
    table.insert(import_name_nodes, import_name)
  end

  local all_export_names_query = vim.treesitter.query.parse(lang, EXPORT_QUERY)

  local export_name_nodes = {}
  for _, export_name, _ in
    all_export_names_query:iter_captures(root, source_bufnr, root:start(), root:end_())
  do
    table.insert(export_name_nodes, export_name)
  end

  return import_name_nodes, export_name_nodes
end

local function find_full_import_for_name(
  missing_import_name,
  all_import_specifiers_nodes,
  source_bufnr
)
  log.trace("missing_import_name", missing_import_name)

  if not missing_import_name then
    return nil
  end

  for _, import_specifier_node in pairs(all_import_specifiers_nodes) do
    local import_specifier_text = vim.treesitter.get_node_text(import_specifier_node, source_bufnr)

    if missing_import_name == import_specifier_text then
      log.trace("Found import for: ", missing_import_name)
      local import_statement_node = find_full_import_statement(import_specifier_node)
      if import_statement_node then
        return import_statement_node
      end
    end
  end

  return nil
end

local function dedupe_imports(nodes)
  local seen = {}
  local result = {}
  for _, node_or_string in ipairs(nodes) do
    local node_id = type(node_or_string) == "string" and node_or_string or node_or_string:id()
    if not seen[node_id] then
      table.insert(result, node_or_string)
      seen[node_id] = true
    end
  end
  return result
end

--- @return table
function M.find_missing_imports(source_bufnr, missing_import_diagnostics)
  local all_import_specifiers_nodes, all_export_specifiers_nodes =
    find_all_import_export_specifiers_nodes(source_bufnr)

  if #all_import_specifiers_nodes == 0 then
    log.error("No import nodes found in source file")
    return {}
  end

  -- for each name in found diagnostics find this name in import list
  local import_nodes_or_strings_to_add = {}
  for _, diagnostic in ipairs(missing_import_diagnostics) do
    for _, missing_import_message in ipairs(utils.constants.missing_import_messages) do
      local missing_import_name = string.match(diagnostic.message, missing_import_message)

      local import_for_missing_name =
        find_full_import_for_name(missing_import_name, all_import_specifiers_nodes, source_bufnr)

      if import_for_missing_name then
        table.insert(import_nodes_or_strings_to_add, import_for_missing_name)
      else
        for _, export_specifier_node in pairs(all_export_specifiers_nodes) do
          local export_specifier_text =
            vim.treesitter.get_node_text(export_specifier_node, source_bufnr)

          if missing_import_name == export_specifier_text then
            table.insert(
              import_nodes_or_strings_to_add,
              "import { "
                .. export_specifier_text
                .. ' } from "'
                .. my_ts_utils.change_relative_absolute_string(
                  vim.api.nvim_buf_get_name(source_bufnr)
                )
                .. '"'
            )
          end
        end
      end
    end
  end

  local deduped_import_nodes_to_add = dedupe_imports(import_nodes_or_strings_to_add)

  return deduped_import_nodes_to_add
end

return M
