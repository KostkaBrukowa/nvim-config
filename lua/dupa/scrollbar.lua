local scrollbar = safe_require("scrollbar")
local scrollbar_gitsigns = safe_require("scrollbar.handlers.gitsigns")

if not scrollbar or not scrollbar_gitsigns then
	return
end

scrollbar.setup()
scrollbar_gitsigns.setup()
