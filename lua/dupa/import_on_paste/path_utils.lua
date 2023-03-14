local M = {}
-- chat-gpt wrote it
-- finds relative string between two paths pathA and pathB
function M.relative_path(pathA, pathB)
	local sep = "/"
	local i = 1

	-- split paths into segments
	local a_segments = {}
	for seg in string.gmatch(pathA, "[^" .. sep .. "]+") do
		a_segments[i] = seg
		i = i + 1
	end

	local b_segments = {}
	i = 1
	for seg in string.gmatch(pathB, "[^" .. sep .. "]+") do
		b_segments[i] = seg
		i = i + 1
	end

	-- find the common path segments
	local j = 1
	while a_segments[j] == b_segments[j] do
		j = j + 1
	end

	-- build relative path
	local rel_path = ""
	-- in the future add to if j == #a_segments to prevent situation like
	-- /home/user/Downloads/ and /home/notUser/Downloads/Downloads
	if #a_segments <= #b_segments and a_segments[#a_segments - 1] == b_segments[#a_segments - 1] then
		rel_path = "./"
	end

	for k = j, #a_segments - 1 do
		rel_path = rel_path .. "../"
	end
	for k = j, #b_segments do
		rel_path = rel_path .. b_segments[k] .. sep
	end
	rel_path = string.sub(rel_path, 1, -2) -- remove trailing separator

	return rel_path
end

-- given the filename full path return directory
-- e.g. /home/user/Downloads/file.txt -> /home/user/Downloads
function M.get_directory(file_path)
	local sep = "/"
	local segments = {}
	local i = 1

	-- split path into segments
	for seg in string.gmatch(file_path, "[^" .. sep .. "]+") do
		segments[i] = seg
		i = i + 1
	end

	-- remove filename from segments
	table.remove(segments)

	-- build directory path
	local directory_path = ""
	for i = 1, #segments do
		directory_path = directory_path .. segments[i] .. sep
	end

	return directory_path
end

return M
