-- TAKEN FROM https://github.com/neovim/neovim/blob/07e6296520fc83b1fdb287b5173494cdd0e9136f/runtime/lua/vim/lsp/diagnostic.lua#L81
-- This part of code is only to Make MULTILINE diagnostics SINGLE
-- So if you have a diagnostic that spans multiple lines, it will be displayed as a single line
local M = {}

local DEFAULT_CLIENT_ID = -1
---@private
local function get_client_id(client_id)
	if client_id == nil then
		client_id = DEFAULT_CLIENT_ID
	end

	return client_id
end

---@private
local function severity_lsp_to_vim(severity)
	if type(severity) == "string" then
		severity = vim.lsp.protocol.DiagnosticSeverity[severity]
	end
	return severity
end

---@private
local function severity_vim_to_lsp(severity)
	if type(severity) == "string" then
		severity = vim.diagnostic.severity[severity]
	end
	return severity
end

local function line_byte_from_position(lines, lnum, col, offset_encoding)
	if not lines or offset_encoding == "utf-8" then
		return col
	end

	local line = lines[lnum + 1]
	local ok, result = pcall(vim.str_byteindex, line, col, offset_encoding == "utf-16")
	if ok then
		return result
	end

	return col
end

local function get_buf_lines(bufnr)
	if vim.api.nvim_buf_is_loaded(bufnr) then
		return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	end

	local filename = vim.api.nvim_buf_get_name(bufnr)
	local f = io.open(filename)
	if not f then
		return
	end

	local content = f:read("*a")
	if not content then
		f:close()
		return
	end

	local lines = vim.split(content, "\n")
	f:close()
	return lines
end

local DUPLICATE_DIAGNOSTICS = {
	["@typescript-eslint/no-explicit-any"] = { -- This one will be removed
		"some_ts_code",
	},
}

local function diagnostic_lsp_to_vim(diagnostics, bufnr, client_id)
	local buf_lines = get_buf_lines(bufnr)
	local client = vim.lsp.get_client_by_id(client_id)
	local offset_encoding = client and client.offset_encoding or "utf-16"

	local filtered_diagnostics = vim.tbl_filter(function(diagnostic)
		if not DUPLICATE_DIAGNOSTICS[diagnostic.code] then
			return true
		end

		local current_line_diagnostics = vim.tbl_filter(function(d)
			return d.range.start.line == diagnostic.range.start.line
		end, diagnostics)

		local duplicated_diagnostics = vim.tbl_filter(function(d)
			return d.code == DUPLICATE_DIAGNOSTICS[diagnostic.code]
		end, current_line_diagnostics)

		return #duplicated_diagnostics == 0
	end, diagnostics)

	return vim.tbl_map(function(diagnostic)
		local start = diagnostic.range.start
		local _end = diagnostic.range["end"]
		return {
			lnum = start.line,
			col = line_byte_from_position(buf_lines, start.line, start.character, offset_encoding),
			-- next two lines were changed
			end_lnum = start.line,
			end_col = start.line == _end.line
					and buf_lines
					and line_byte_from_position(buf_lines, _end.line, _end.character, offset_encoding)
				or #buf_lines[start.line + 1],
			severity = severity_lsp_to_vim(diagnostic.severity),
			message = diagnostic.source and diagnostic.source .. ": " .. diagnostic.message or diagnostic.message,
			source = diagnostic.source,
			code = diagnostic.code,
			user_data = {
				lsp = {
					-- usage of user_data.lsp.code is deprecated in favor of the top-level code field
					code = diagnostic.code,
					codeDescription = diagnostic.codeDescription,
					tags = diagnostic.tags,
					relatedInformation = diagnostic.relatedInformation,
					data = diagnostic.data,
				},
			},
		}
	end, diagnostics)
end

---@private
local function diagnostic_vim_to_lsp(diagnostics)
	return vim.tbl_map(function(diagnostic)
		return vim.tbl_extend("keep", {
			range = {
				start = {
					line = diagnostic.lnum,
					character = diagnostic.col,
				},
				["end"] = {
					line = diagnostic.end_lnum,
					character = diagnostic.end_col,
				},
			},
			severity = severity_vim_to_lsp(diagnostic.severity),
			message = diagnostic.message,
			source = diagnostic.source,
			code = diagnostic.code,
		}, diagnostic.user_data and (diagnostic.user_data.lsp or {}) or {})
	end, diagnostics)
end

local _client_namespaces = {}

function M.get_namespace(client_id)
	vim.validate({ client_id = { client_id, "n" } })
	if not _client_namespaces[client_id] then
		local client = vim.lsp.get_client_by_id(client_id)
		local name = string.format("vim.lsp.%s.%d", client and client.name or "unknown", client_id)
		_client_namespaces[client_id] = vim.api.nvim_create_namespace(name)
	end
	return _client_namespaces[client_id]
end

function M.on_publish_diagnostics(_, result, ctx, config)
	local client_id = ctx.client_id
	local uri = result.uri
	local fname = vim.uri_to_fname(uri)
	local diagnostics = result.diagnostics
	if #diagnostics == 0 and vim.fn.bufexists(fname) == 0 then
		return
	end
	local bufnr = vim.fn.bufadd(fname)

	if not bufnr then
		return
	end

	client_id = get_client_id(client_id)
	local namespace = M.get_namespace(client_id)

	if config then
		for _, opt in pairs(config) do
			if type(opt) == "table" then
				if not opt.severity and opt.severity_limit then
					opt.severity = { min = severity_lsp_to_vim(opt.severity_limit) }
				end
			end
		end

		vim.diagnostic.config(config, namespace)
	end

	vim.diagnostic.set(namespace, bufnr, diagnostic_lsp_to_vim(diagnostics, bufnr, client_id))
end

function M.reset(client_id, buffer_client_map)
	buffer_client_map = vim.deepcopy(buffer_client_map)
	vim.schedule(function()
		for bufnr, client_ids in pairs(buffer_client_map) do
			if client_ids[client_id] then
				local namespace = M.get_namespace(client_id)
				vim.diagnostic.reset(namespace, bufnr)
			end
		end
	end)
end

return M
