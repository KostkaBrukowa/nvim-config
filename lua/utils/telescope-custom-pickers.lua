local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local action_state = require("telescope.actions.state")

local M = {}

M.merge_branch = function()
	builtin.git_branches({
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection_value = action_state.get_selected_entry().value
				vim.cmd("Git merge " .. selection_value)
			end)

			return true
		end,
	})
end

return M
