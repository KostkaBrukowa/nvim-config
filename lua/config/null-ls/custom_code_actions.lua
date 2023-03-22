local null_ls = require("null-ls")
local h = require("null-ls.helpers")
local cmd_resolver = require("null-ls.helpers.command_resolver")
local methods = require("null-ls.methods")
local u = require("null-ls.utils")
local ts_utils = require("utils.treesitter-utils")
local file_utils = require("utils.file")

local CODE_ACTION = methods.internal.CODE_ACTION

local generate_edit_line_action = function(command)
	return {
		title = "Run command",
		action = function()
			local runner = file_utils.file_exists_in_project_root("yarn.lock") and "yarn run " or "npm run "
			command = runner .. command:gsub('"', "")
			vim.notify("Running command: " .. command)
			vim.cmd('TermExec cmd="' .. command .. '"')
		end,
	}
end

local test = h.make_builtin({
	name = "Run command from package json",
	meta = {},
	method = CODE_ACTION,
	filetypes = { "json" },
	generator_opts = {
		command = "echo",
		format = "json_raw",
		args = {},
		to_stdin = true,
		check_exit_code = { 0, 1 },
		use_cache = true,
		on_output = function(params)
			local range = params.lsp_params.range
			local node_under_cursor =
				ts_utils.get_ts_node_at(0, { row = range.start.line + 1, col = range.start.character })

			if
				not node_under_cursor
				or node_under_cursor:type() ~= "string"
				or not node_under_cursor:parent()
				or node_under_cursor:parent():type() ~= "pair"
				or not vim.treesitter.get_node_text(node_under_cursor:parent():parent():parent(), 0):find('^"scripts')
			then
				return
			end

			return {
				generate_edit_line_action(vim.treesitter.get_node_text(node_under_cursor, 0)),
			}
		end,
	},
	factory = h.generator_factory,
})

local function setup()
	null_ls.register(test)
end

return {
	setup = setup,
}
