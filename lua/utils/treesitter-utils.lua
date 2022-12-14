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
			or (node:type() == "call_expression" and ts.get_node_text(node:field("function")[1], 0) ~= "i18n")
		)
	do
		node = node:parent()
	end

	if not node then
		print('There is no "i18n" function under cursor!')
		return false
	end

	local args = node:field("arguments")[1]
	local name = ts_utils.get_node_text(args:child(1):child(1), 0)[1]

	if name then
		local po_winid = vim.fn.bufwinid(vim.fn.bufnr("src/translations/pl-PL.po"))

		if po_winid == -1 then
			vim.cmd(":vs ./src/translations/pl-PL.po")
		else
			vim.api.nvim_set_current_win(po_winid)
		end
		vim.cmd('/"' .. name .. '"')
		vim.cmd("nohl")

		return true
	end

	return false
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

	return root:descendant_for_range(nvim_row, nvim_col, nvim_row, nvim_col)
end

return M
