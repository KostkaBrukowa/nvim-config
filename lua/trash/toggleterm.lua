local toggleterm = safe_require("toggleterm")

if not toggleterm then
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-`>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = false,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		height = 30,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<esc><esc>", "<cmd>wincmd j<cr>", opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
