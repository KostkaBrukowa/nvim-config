local ok, tst = pcall(require, "typescript-tools")

if not ok then
	return
end

tst.setup({
	settings = {
		-- tsserver_logs = { file_basename = "/Users/jaroslaw.glegola/.config/nvim/", verbosity = "verbose" },
		composite_mode = "separate_diagnostic",
		publish_diagnostic_on = "insert_leave",
	},
})
