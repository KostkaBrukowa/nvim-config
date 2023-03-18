local dressing = safe_require("dressing")

if not dressing then
	return
end

dressing.setup({
	input = {
		enabled = true,
	},
	select = {
		telescope = {
			initial_mode = "normal",
		},
	},
})
