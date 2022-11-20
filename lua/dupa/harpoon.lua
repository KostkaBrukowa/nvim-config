local harpoon = safe_require("harpoon")

if not harpoon then
	return
end

harpoon.setup({})
-- make tab in normal mode cycle through marks
--[[ keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", opts) ]]
--[[ keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opts) ]]
