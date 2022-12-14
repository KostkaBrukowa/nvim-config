vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set fillchars+=diff:╱]])

vim.cmd([[set fillchars+=vert:┃]])
vim.cmd([[set fillchars+=horiz:━]])
vim.cmd([[set fillchars+=horizup:┻]])
vim.cmd([[set fillchars+=horizdown:┳]])
vim.cmd([[set fillchars+=vertleft:┫]])
vim.cmd([[set fillchars+=vertright:┣]])
vim.cmd([[set fillchars+=verthoriz:╋]])

vim.opt.shortmess:append("c")
vim.notify = require("notify")

local options = {
	backup = false,
	cmdheight = 0,
	laststatus = 3,
	completeopt = { "menuone", "noselect" },
	conceallevel = 0,
	fileencoding = "utf-8",
	hlsearch = true,
	ignorecase = true,
	mouse = "a",
	pumheight = 10,
	showmode = false,
	showtabline = 0,
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	termguicolors = true,
	undofile = true,
	updatetime = 300,
	writebackup = false,
	expandtab = true,
	shiftwidth = 2,
	tabstop = 2,
	cursorline = true,
	number = true,
	relativenumber = true,
	numberwidth = 4,
	signcolumn = "yes",
	wrap = false,
	scrolloff = 8,
	switchbuf = "useopen,usetab",
	sidescrolloff = 8,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd([[
  autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'a': {'argument': [{'o': '(', 'c': ')', 's': ','}, {'o': '[', 'c': ']', 's': ','}, {'o': '{', 'c': '}', 's': ','}]},
      \ 't': {},
      \ 'b': {},
      \ 'q': {},
      \ })
]])
