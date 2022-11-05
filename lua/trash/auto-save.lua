local auto_save = safe_require("auto-save")

if not auto_save then
	return
end

auto_save.setup({
    trigger_events = { "FocusLost" }, -- vim events that trigger auto-save. See :h events
})
