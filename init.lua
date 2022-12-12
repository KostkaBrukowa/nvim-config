require("dupa.colorscheme")
require("dupa.utils")
require("dupa.options")
require("dupa.mappings")
require("dupa.packer-plugins")
require("dupa.treesitter")
require("dupa.which-key")
require("dupa.nvim-tree")
require("dupa.lualine")
require("dupa.telescope")
require("dupa.cmp")
require("dupa.autopairs")
require("dupa.impatient")
require("dupa.alpha")
require("dupa.comment")
require("dupa.lastplace")
require("dupa.lsp")
require("dupa.true-zen")
require("dupa.dressing")
require("dupa.toggleterm")
require("dupa.lsp-saga")
require("dupa.auto-save")
require("dupa.tint")
require("dupa.spectre")
require("dupa.git")
require("dupa.other")
require("dupa.neotest")
require("dupa.dap")
require("dupa.tint")
require("config.luasnip")
require("dupa.auto-session")
require("dupa.null-ls")
require("dupa.hydra")
require("dupa.haskell")
require("dupa.ufo")
require("dupa.stickybuf")
require("dupa.other_plugins")

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

local init_lua = vim.fn.stdpath("config") .. "/lua/dupa/mappings.lua"
watch_file(init_lua, function()
	dofile(init_lua)
	vim.notify("Reloaded mapping.lua", vim.diagnostic.severity.INFO)
end, 500)

local init_lua = vim.fn.stdpath("config") .. "/lua/dupa/which-key.lua"
watch_file(init_lua, function()
	dofile(init_lua)
	vim.notify("Reloaded which-key.lua", vim.diagnostic.severity.INFO)
end, 500)

local init_lua = vim.fn.stdpath("config") .. "/lua/dupa/nvim-tree.lua"
watch_file(init_lua, function()
	dofile(init_lua)
	vim.notify("Reloaded nvim-tree.lua", vim.diagnostic.severity.INFO)
end, 500)

local init_lua = vim.fn.stdpath("config") .. "/lua/dupa/colorscheme.lua"
watch_file(init_lua, function()
	dofile(init_lua)
	vim.notify("Reloaded colorscheme.lua", vim.diagnostic.severity.INFO)
end, 500)
