local session = safe_require("auto-session")

if not session then
	return
end

session.setup({
	log_level = "error",
	auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
})

local session_file_augroup = "session_load_augroup"

-- Remove troublesome buffers after session load
vim.api.nvim_create_autocmd("SessionLoadPost", {
	callback = function()
		local buffers = vim.api.nvim_list_bufs()
		for _, buffer in ipairs(buffers) do
			local buffer_name = vim.api.nvim_buf_get_name(buffer)
			print(vim.inspect(buffer_name))
			if string.find(buffer_name, "Neotest Summary") or string.find(buffer_name, "#toggleterm") then
				vim.api.nvim_command("bwipeout! " .. buffer)
			end
		end
	end,
})
