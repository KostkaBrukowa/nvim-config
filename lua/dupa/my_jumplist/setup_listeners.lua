local M = {}
local keymap_amend = require("keymap-amend")
local CONSTANTS = require("dupa.my_jumplist.consts")

local function setup_keymaps()
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_set_keymap

	keymap("n", "<C-l>", "<cmd>lua require('dupa.my_jumplist').go_back()<cr>", opts)
	keymap("n", "<C-u>", "<cmd>lua require('dupa.my_jumplist').go_forward()<cr>", opts)
	keymap("n", "<leader><leader>d", "<cmd>lua require('dupa.my_jumplist').debug()<cr>", opts)
end

local function setup_events_on_keys()
	local function emit_jump_tree_event()
		vim.cmd("doautocmd User " .. CONSTANTS.CUSTOM_TRIGGER_EVENT)
	end

	local function keymap_amend_event_before(original)
		emit_jump_tree_event()
		original()
	end

	local function keymap_amend_event_after(original)
		original()
		emit_jump_tree_event()
	end

	keymap_amend("n", "gg", keymap_amend_event_before)
	keymap_amend("n", "G", keymap_amend_event_before)
	keymap_amend("n", "m", keymap_amend_event_after)
end

--- @param push_new_entry function
function M.setup_listeners(push_new_entry)
	local save_jump_group = vim.api.nvim_create_augroup("save_jump_group", {})
	vim.api.nvim_create_autocmd({ "BufLeave", "BufEnter" }, {
		group = save_jump_group,
		pattern = "*",
		callback = push_new_entry,
	})

	vim.api.nvim_create_autocmd("User", {
		group = save_jump_group,
		pattern = CONSTANTS.CUSTOM_TRIGGER_EVENT,
		callback = push_new_entry,
	})

	setup_keymaps()
	setup_events_on_keys()
end

return M
