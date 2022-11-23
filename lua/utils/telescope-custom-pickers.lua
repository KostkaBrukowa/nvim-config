local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local action_state = require("telescope.actions.state")

local M = {}

function M.merge_branch()
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

function M.checkout_remote_smart()
	builtin.git_branches({
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection_value = action_state.get_selected_entry().value
				if string.find(selection_value, "origin/") then
					vim.cmd("Git checkout --track " .. selection_value)
				else
					vim.cmd("Git checkout " .. selection_value)
				end
			end)

			return true
		end,
	})
end

function M.find_in_focused_file(node)
	if node.type == "directory" then
		builtin.live_grep({ search_dirs = { node.absolute_path }, prompt_title = "Live grep: " .. node.absolute_path })
	elseif node.parent ~= nil then
		builtin.live_grep({
			search_dirs = { node.parent.absolute_path },
			prompt_title = "Live grep: " .. node.parent.absolute_path,
		})
	end
end

function M.last_picker(node)
	local handle_input = function(input)
		local input_number = tonumber(input)
		if not input or not input_number then
			return
		end

		builtin.resume({ cache_index = input_number })
	end

	vim.ui.input({
		prompt = "Enter a numer for picker (min. 1): ",
	}, handle_input)
end

return M
