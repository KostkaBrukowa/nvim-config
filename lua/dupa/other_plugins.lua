require("leap").setup({})
require("messages").setup()
require("substitute").setup({})
require("nvim-surround").setup()
require("refactoring").setup({})
require("eyeliner").setup({})
require("local-highlight").setup({})
require("package-info").setup({})
require("notify").setup({
	stages = "fade",
	timeout = 3000,
})
require("lsp-file-operations").setup({
	debug = false,
})
