-- This file was stolen from LunarVim repository
local M = {}

local function _assign(old, new, k)
	local otype = type(old[k])
	local ntype = type(new[k])
	if (otype == "thread" or otype == "userdata") or (ntype == "thread" or ntype == "userdata") then
		vim.notify(string.format("warning: old or new attr %s type be thread or userdata", k))
	end
	old[k] = new[k]
end

local function _replace(old, new, repeat_tbl)
	if repeat_tbl[old] then
		return
	end
	repeat_tbl[old] = true

	local dellist = {}
	for k, _ in pairs(old) do
		if not new[k] then
			table.insert(dellist, k)
		end
	end
	for _, v in ipairs(dellist) do
		old[v] = nil
	end

	for k, _ in pairs(new) do
		if not old[k] then
			old[k] = new[k]
		else
			if type(old[k]) ~= type(new[k]) then
				_assign(old, new, k)
			else
				if type(old[k]) == "table" then
					_replace(old[k], new[k], repeat_tbl)
				else
					_assign(old, new, k)
				end
			end
		end
	end
end

M.require_clean = function(m)
	package.loaded[m] = nil
	_G[m] = nil
	local _, module = pcall(require, m)
	return module
end

_G.safe_require = function(module_name)
	local package_exists, module = pcall(require, module_name)
	if not package_exists then
		vim.defer_fn(function()
			vim.schedule(function()
				vim.notify("Could not load module: " .. module_name, "error", { title = "Module Not Found" })
			end)
		end, 1000)
		return nil
	else
		return module
	end
end

M.reload = function(mod)
	if not package.loaded[mod] then
		return safe_require(mod)
	end

	local old = package.loaded[mod]
	package.loaded[mod] = nil
	local new = safe_require(mod)

	if type(old) == "table" and type(new) == "table" then
		local repeat_tbl = {}
		_replace(old, new, repeat_tbl)
	end

	package.loaded[mod] = old
	return old
end

_G.reload = M.reload

return M
