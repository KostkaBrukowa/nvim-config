local trueZen = safe_require("true-zen")

if not trueZen then
	return
end

trueZen.setup({
	modes = {
		ataraxis = {
			minimum_writing_area = { -- minimum size of main window
				width = 100,
			},
		},
		kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
			enabled = true,
		},
		minimalist = {
			options = {
				number = true,
				relativenumber = true,
				ruler = true,
			},
		},
	},
})
