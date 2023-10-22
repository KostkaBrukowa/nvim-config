local M = {}

function M.extend(dst, ...)
  for _, it in ipairs({ ... }) do
    vim.list_extend(dst, it)
  end

  return dst
end

function M.stable_sort(arr, compare)
  compare = compare or function(a, b)
    return a < b
  end

  for i = 2, #arr do
    local key = arr[i]
    local j = i - 1
    while j > 0 and compare(key, arr[j]) do
      arr[j + 1] = arr[j]
      j = j - 1
    end
    arr[j + 1] = key
  end
end

return M
