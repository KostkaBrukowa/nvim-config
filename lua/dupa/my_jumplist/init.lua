local log = require("dupa.log")
local util = require("dupa.my_jumplist.util")
local setup = require("dupa.my_jumplist.setup_listeners")
local Tree = require("dupa.my_jumplist.tree")

local M = {}

local jump_tree = Tree:new(util.jumps_equal)

function M.push_new_entry_to_jumplist(args)
	log.debug(vim.inspect(args))
	local jump_entry = util.make_current_position_entry()

	jump_tree:push_entry(jump_entry)
end

function M.go_back()
	if not jump_tree.current_entry_with_index then
		return
	end

	local current_user_entry = util.make_current_position_entry()

	-- when cursor is not on last jump position jump to that jump - webstorm does not do that
	local current_jump_tree_entry = jump_tree.current_entry_with_index.entry
	if not util.jumps_equal(current_user_entry, current_jump_tree_entry) then
		vim.api.nvim_win_set_cursor(0, current_jump_tree_entry.cursor_position)
		return
	end

	local previous_jump = jump_tree:go_back()

	-- if no previous jumps are available stay in current spot
	if not previous_jump then
		return
	end

	if previous_jump.file_name ~= current_user_entry.file_name then
		-- skipping two entries to omit BufEnter and BufLeave after edit
		jump_tree:skip(2)
		vim.cmd("e " .. previous_jump.file_name)
		vim.api.nvim_win_set_cursor(0, previous_jump.cursor_position)
	else
		vim.api.nvim_win_set_cursor(0, previous_jump.cursor_position)
	end
end

function M.go_forward()
	local current_position_entry = util.make_current_position_entry()

	local next_jump = jump_tree:go_forward()
	-- if no next jumps are available stay in current spot
	if not next_jump then
		return
	end

	if next_jump.file_name ~= current_position_entry.file_name then
		-- skipping two entrie to omit BufEnter and BufLeave after edit
		jump_tree:skip(2)
		vim.cmd("e " .. next_jump.file_name)
		vim.api.nvim_win_set_cursor(0, next_jump.cursor_position)
	else
		vim.api.nvim_win_set_cursor(0, next_jump.cursor_position)
	end
end

function M.debug()
	log.trace("jumptree", vim.inspect(jump_tree.jumptree), jump_tree.current_entry_with_index.index)
end

-- TODO do a setup function and export
setup.setup_listeners(M.push_new_entry_to_jumplist)

return M
