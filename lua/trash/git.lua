local signs = safe_require("gitsigns")
local utils = safe_require("utils")

if not signs or not utils then
	return
end

signs.setup({
	attach_to_untracked = true,
	signs = {
		add = { hl = "GitSignsAdd", text = "█", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "█", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "▬", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		untracked = { hl = "GitSignsAdd", text = "┇", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
	},
})

-- Add jira task to commit message
utils.create_onetime_autocmd("FileType", {
	pattern = "gitcommit",
	callback = function()
		local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)[1]

		if content ~= "" and content:find("^Merge branch") == nil then
			return
		end

		local branch = vim.fn.system("git branch --show-current"):match("/?([%u%d]+-%d+)-?")

		if branch then
			vim.api.nvim_buf_set_lines(0, 0, -1, false, { branch .. " | " })
			vim.cmd(":startinsert!")
		end
	end,
})

vim.api.nvim_create_user_command("DiffviewToggle", function(e)
	local view = require("diffview.lib").get_current_view()

	if view then
		vim.cmd("DiffviewClose")
	else
		vim.cmd("DiffviewOpen " .. e.args)
	end
end, { nargs = "*" })
