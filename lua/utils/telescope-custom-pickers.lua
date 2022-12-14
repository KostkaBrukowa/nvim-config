local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local action_state = require("telescope.actions.state")
local project_actions = require("telescope._extensions.project.actions")

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

-- Checkout to searched branch and creates one if branch is remote and doesnt exist
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

-- Open project in new kitty window
function M.open_saved_project_picker()
	require("telescope").extensions.project.project({
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection_value = action_state.get_selected_entry().value

				local handle_select_choice = function(picked_option)
					if picked_option == "This window" then
						vim.cmd("e " .. selection_value)
					elseif picked_option == "New window" then
						vim.cmd("silent ! kitty -d " .. selection_value .. " --single-instance --instance-group 100 &")
					end
				end

				vim.ui.select(
					{ "New window", "This window" },
					{ prompt = "Open " .. selection_value .. " in: " },
					handle_select_choice
				)
			end)
			return true
		end,
	})
end

-- If you are in nvimtree and you are focused on some folder this command
-- will open live grep only in this directory
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

function M.find_file_in_focused_file(node)
	if node.type == "directory" then
		builtin.find_files({ search_dirs = { node.absolute_path }, prompt_title = "Find files: " .. node.absolute_path })
	elseif node.parent ~= nil then
		builtin.find_files({
			search_dirs = { node.parent.absolute_path },
			prompt_title = "Find files: " .. node.parent.absolute_path,
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

function M.open_file_from_word()
	local current_word = vim.fn.expand("<cWORD>")
	local colon_index = current_word:find(":")

	local filename_from_word = colon_index and current_word:sub(0, colon_index - 1) or current_word

	vim.cmd("e " .. filename_from_word)
	if not colon_index then
		return
	end

	local position = current_word:sub(colon_index + 1)
	if position:find(":") then
		local line, col = position:match("(%d+):(%d+)")
		vim.api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) })
	else
		vim.api.nvim_win_set_cursor(0, { tonumber(position), 0 })
	end
end

-- lua/dupa/toggleterm.lua:12

return M
