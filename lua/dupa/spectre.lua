local spectre = safe_require("spectre")

if not spectre then
  return
end

spectre.setup({
  highlight = {
    ui = "String",
    search = "SpectreReplace",
    replace = "Search",
  },
})
