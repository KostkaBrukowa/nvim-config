local M = {}

M.refine_filename = function(filename, cwd)
	if cwd ~= nil then
		cwd = vim.loop.cwd()
	end
	local relative_filename = require("plenary.path"):new(filename):make_relative(cwd)
	local name = relative_filename:match("[^/]*$")
	local filename_split = vim.split(relative_filename, "/", { trimempty = true })
	local dir = filename_split[#filename_split - 1] or ""
	local icon, hl_icon = require("telescope.utils").transform_devicons(filename)
	return { " " .. icon, hl_icon }, { dir .. "/", "TelescopeResultsSpecialComment" }, { name }
end

return M
