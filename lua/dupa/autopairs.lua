local autopairs = safe_require("nvim-autopairs")

if not autopairs then
  return
end

autopairs.setup({
  check_ts = true,
})

local cmp_autopairs = safe_require("nvim-autopairs.completion.cmp")

if not cmp_autopairs then
  return
end

local cmp = safe_require("cmp")

if not cmp then
  return
end

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
