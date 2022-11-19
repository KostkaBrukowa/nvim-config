require("trash.utils")
require("trash.options")
require("trash.mappings")
require("trash.plugins")
require("trash.treesitter")
require("trash.which-key")
require("trash.nvim-tree")
require("trash.lualine")
require("trash.telescope")
require("trash.cmp")
require("trash.autopairs")
require("trash.impatient")
require("trash.alpha")
require("trash.comment")
require("trash.indent_blankline")
require("trash.lastplace")
require("trash.tabout")
require("trash.lsp")
require("trash.null-ls")
require("trash.true-zen")
require("trash.dressing")
require("trash.toggleterm")
require("trash.scrollbar")
require("trash.lsp-saga")
require("trash.auto-save")
require("trash.leap")
require("trash.tint")
require("trash.auto-session")
require("trash.colorscheme")
require("trash.spectre")
require("trash.git")
require("trash.other")
require("trash.neotest")
require("trash.dap")
require("trash.tint")
require("trash.notify")

-- Restart nvim after lua config change
if File_watchers == nil then
	File_watchers = {}
end
local watch_file_augroup = "watch_file_augroup"
vim.api.nvim_create_augroup(watch_file_augroup, { clear = true })
vim.api.nvim_create_autocmd("VimLeave", {
	group = watch_file_augroup,
	callback = function()
		for _, watcher in pairs(File_watchers) do
			watcher:stop()
		end
	end,
})
local function watch_file(fname, cb, time)
	if File_watchers[fname] then
		File_watchers[fname]:stop()
		File_watchers[fname] = nil
	end

	File_watchers[fname] = vim.loop.new_fs_poll()
	File_watchers[fname]:start(fname, time, vim.schedule_wrap(cb))
end

local init_lua = vim.fn.stdpath("config") .. "/init.lua"
watch_file(init_lua, function()
	dofile(init_lua)
	vim.notify("Reloaded init.lua", vim.diagnostic.severity.INFO)
end, 500)

local init_lua = vim.fn.stdpath("config") .. "/lua/trash/mappings.lua"
watch_file(init_lua, function()
	dofile(init_lua)
	vim.notify("Reloaded mapping.lua", vim.diagnostic.severity.INFO)
end, 500)

local init_lua = vim.fn.stdpath("config") .. "/lua/trash/which-key.lua"
watch_file(init_lua, function()
	dofile(init_lua)
	vim.notify("Reloaded which-key.lua", vim.diagnostic.severity.INFO)
end, 500)

local init_lua = vim.fn.stdpath("config") .. "/lua/trash/nvim-tree.lua"
watch_file(init_lua, function()
	dofile(init_lua)
	vim.notify("Reloaded nvim-tree.lua", vim.diagnostic.severity.INFO)
end, 500)

local init_lua = vim.fn.stdpath("config") .. "/lua/trash/colorscheme.lua"
watch_file(init_lua, function()
	dofile(init_lua)
	vim.notify("Reloaded colorscheme.lua", vim.diagnostic.severity.INFO)
end, 500)
