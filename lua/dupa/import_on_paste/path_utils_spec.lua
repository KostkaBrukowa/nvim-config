local relative_path = require("dupa.import_on_paste.path_utils").relative_path

describe("HandlerCoroutine", function()
  it("should correctly convert 1", function()
    local pathA =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/components/brands/__tests__/"
    local pathB =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/components/brands/list/BrandsList"

    local result = relative_path(pathA, pathB)

    assert.same("../list/BrandsList", result)
  end)

  it("should correctly convert 2", function()
    local pathA =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/components/brands/"
    local pathB =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/components/brands/list/BrandsList"

    local result = relative_path(pathA, pathB)

    assert.same("./list/BrandsList", result)
  end)

  it("should correctly convert 3", function()
    local pathA =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/components/brands/"
    local pathB =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/components/BrandsList"

    local result = relative_path(pathA, pathB)

    assert.same("../BrandsList", result)
  end)

  it("should correctly convert 4", function()
    local pathA =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/components/brands/"
    local pathB = "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/BrandsList"

    local result = relative_path(pathA, pathB)

    assert.same("../../BrandsList", result)
  end)

  it("should correctly convert 5", function()
    local pathA =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/components/brands/"
    local pathB =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/components/brands/BrandsList"

    local result = relative_path(pathA, pathB)

    assert.same("./BrandsList", result)
  end)

  it("should correctly convert 6", function()
    local pathA =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/components/brands/"
    local pathB =
      "Users/jaroslaw.glegola/Documents/Praca/opbox-ads-panel/src/client/notcomponents/brands/BrandsList"

    local result = relative_path(pathA, pathB)

    assert.same("../../notcomponents/BrandsList", result)
  end)
end)
