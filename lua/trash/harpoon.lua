local harpoon = safe_require("harpoon")

if not harpoon then
	return
end

harpoon.setup({})

local watch_file_augroup = "harpoon_watch_file"

--[[ vim.api.nvim_create_autocmd("VimLeave", { ]]
--[[ 	group = watch_file_augroup, ]]
--[[ 	callback = function() ]]
--[[ 		for _, watcher in pairs(File_watchers) do ]]
--[[ 			watcher:stop() ]]
--[[ 		end ]]
--[[ 	end, ]]
--[[ }) ]]
