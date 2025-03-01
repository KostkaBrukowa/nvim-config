vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set fillchars+=diff:╱]])
vim.opt.fillchars:append("fold:•")

vim.cmd([[set fillchars+=vert:┃]])
vim.cmd([[set fillchars+=horiz:━]])
vim.cmd([[set fillchars+=horizup:┻]])
vim.cmd([[set fillchars+=horizdown:┳]])
vim.cmd([[set fillchars+=vertleft:┫]])
vim.cmd([[set fillchars+=vertright:┣]])
vim.cmd([[set fillchars+=verthoriz:╋]])
vim.cmd([[set jumpoptions+=stack]])
vim.cmd([[set indentexpr=nvim_treesitter#indent()]])

vim.opt.shortmess:append("nocI")
-- vim.notify = require("notify")

vim.o.sessionoptions = "buffers,curdir,winpos,winsize,terminal"

local options = {
  backup = false,
  cmdheight = vim.g.vscode and 2 or 1,
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
  smartindent = false,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  undofile = true,
  updatetime = 700,
  writebackup = false,
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  cursorline = true,
  number = true,
  relativenumber = true,
  numberwidth = 4,
  signcolumn = "yes",
  showcmd = false,
  wrap = false,
  scrolloff = 8,
  switchbuf = "useopen,usetab",
  sidescrolloff = 8,
  spelllang = "en_us,pl",
  spell = not vim.g.vscode,
  spelloptions = "camel,noplainbuffer",
  spellcapcheck = "",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
