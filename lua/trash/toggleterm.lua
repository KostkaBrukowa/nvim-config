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
	direction = "horizontal",
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
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-n>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-e>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-i>", [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
