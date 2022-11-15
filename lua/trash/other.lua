local other = safe_require("other-nvim")
local list = safe_require("utils.list")

if not other or not list then
	return
end

local function ts_tests(suffix)
	local test_ext = string.format(".%s.[tj]sx?", suffix)

	return {
		{
			pattern = "/(.*)/(.*).([tj]sx?)$",
			target = {
				{
					target = "/%1/__tests__/%2." .. suffix .. ".%3",
					context = "test",
				},
				{
					target = "/%1/%2." .. suffix .. ".%3",
					context = "test",
				},
			},
		},
		{
			pattern = "/(.*)/__tests__/(.*)." .. suffix .. ".([tj]sx?)$",
			target = "/%1/%2.%3",
			context = "test",
		},
		{
			pattern = "/(.*)/(.*)." .. test_ext .. ".([tj]sx?)$",
			target = "/%1/%2.%3",
			context = "test",
		},
	}
end

other.setup({
	mappings = list.extend({}, ts_tests("spec"), ts_tests("test")),
})
