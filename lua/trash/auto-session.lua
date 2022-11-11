local session = safe_require("auto-session")

if not session then
	return
end

session.setup({
	log_level = "error",
	auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
})
