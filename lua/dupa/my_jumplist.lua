local log = require("dupa.log")
local M = {}

local function jumps_equal(a, b)
	if not a or not b then
		return false
	end
	local cursorA = a.cursor_position
	local cursorB = b.cursor_position
	return cursorA[1] == cursorB[1] and cursorA[2] == cursorB[2] and a.file_name == b.file_name
end

local function make_current_jump()
	local jump = { cursor_position = vim.api.nvim_win_get_cursor(0), file_name = vim.fn.expand("%") }
	return jump
end

--- @class RequestQueue
--- @field jumplist table
--- @field entry_comparator function
local Tree = {
	Priority = {
		Low = 1,
		Normal = 2,
		Const = 3,
	},
}

--- @param entry_comparator function
--- @return RequestQueue
function Tree:new(entry_comparator)
	local obj = {
		jumplist = {},
		current_entry = nil,
		entry_comparator = entry_comparator,
		amount_to_skip = 0,
	}

	setmetatable(obj, self)
	self.__index = self

	return obj
end

function Tree:make_entry(entry, index)
	return {
		entry = entry,
		index = index,
	}
end

function Tree:should_push_entry(entry)
	if not entry then
		log.trace("should_push_entry: entry is nil")
		return false
	end

	if entry.file_name == "" then
		log.trace("should_push_entry: entry.file_name is empty")
		return false
	end

	if self.current_entry and self.entry_comparator(entry, self.current_entry.entry) then
		log.trace("should_push_entry: entry is equal to current entry")
		return false
	end

	if self.amount_to_skip > 0 then
		log.trace("should_push_entry: skipping entry due to amount_to_skip")
		self.amount_to_skip = self.amount_to_skip - 1
		return false
	end

	return true
end

--- @param entry table
function Tree:push_entry(entry)
	if not self:should_push_entry(entry) then
		return
	end

	-- remove all entries from jumplist after current_entry index
	if self.current_entry then
		for i = #self.jumplist, self.current_entry.index + 1, -1 do
			table.remove(self.jumplist, i)
		end
	end

	self.jumplist[#self.jumplist + 1] = entry
	self.current_entry = self:make_entry(entry, #self.jumplist)
	log.trace("pushed entry", vim.inspect(self.current_entry))
end

--- @param entry_before_back table
--- @return table | nil
function Tree:go_back(entry_before_back)
	if self.current_entry == nil then
		log.trace("go_back: current_entry is nil")
		return nil
	end

	-- -- if we go back from last time we pushed entry we need to add new entry to jumplist
	-- if self.current_entry.index == #self.jumplist then
	-- 	self:push_entry(entry_before_back)
	-- end

	local previous_entry_index = self.current_entry.index - 1

	if previous_entry_index < 1 then
		log.trace("go_back: previous_entry_index is less than 1")
		return nil
	end

	local previous_entry = self.jumplist[previous_entry_index]

	self.current_entry = self:make_entry(previous_entry, previous_entry_index)
	log.trace("go_back with: ", vim.inspect(self.current_entry))

	return self.current_entry.entry
end

--- @return table | nil
function Tree:go_forward()
	if self.current_entry == nil then
		return nil
	end

	local next_entry_index = self.current_entry.index + 1

	if next_entry_index > #self.jumplist then
		return nil
	end

	local next_entry = self.jumplist[next_entry_index]

	self.current_entry = self:make_entry(next_entry, next_entry_index)
	log.trace("go_forward with: ", vim.inspect(self.current_entry))

	return self.current_entry.entry
end

--- @return boolean
function Tree:is_empty()
	return #self.jumplist > 0
end

--- @param amount number
function Tree:skip(amount)
	self.amount_to_skip = amount
end

local jump_tree = Tree:new(jumps_equal)

vim.api.nvim_create_augroup("save_to_jumplist", {})

local function should_skip_file(file)
	if file == "" or string.find(file, "NvimTree_") then
		log.trace("should_skip_file: file name is empty")
		return true
	end
end

vim.api.nvim_create_autocmd("BufEnter", {
	group = "save_to_jumplist",
	pattern = "*",
	callback = function(args)
		if should_skip_file(args.file) then
			return
		end
		log.debug(vim.inspect(args))
		local jump = make_current_jump()

		jump_tree:push_entry(jump)
	end,
})

vim.api.nvim_create_autocmd("BufLeave", {
	group = "save_to_jumplist",
	pattern = "*",
	callback = function(args)
		if should_skip_file(args.file) then
			return
		end
		log.debug(vim.inspect(args))
		local jump = make_current_jump()

		jump_tree:push_entry(jump)
	end,
})

function M.go_back()
	local current_jump = make_current_jump()
	local previous_jump = jump_tree:go_back(current_jump)
	if not previous_jump then
		return
	end

	if previous_jump.file_name ~= current_jump.file_name then
		-- skipping two entrie to omit BufEnter and BufLeave after edit
		jump_tree:skip(2)
		vim.cmd("e " .. previous_jump.file_name)
		vim.api.nvim_win_set_cursor(0, previous_jump.cursor_position)
	else
		vim.api.nvim_win_set_cursor(0, previous_jump.cursor_position)
	end
end

function M.debug()
	log.trace("jumplist", vim.inspect(jump_tree.jumplist), jump_tree.current_entry.index)
end

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<leader><leader>l", "<cmd>lua require('dupa.my_jumplist').go_back()<cr>", opts)
keymap("n", "<leader><leader>d", "<cmd>lua require('dupa.my_jumplist').debug()<cr>", opts)

return M
