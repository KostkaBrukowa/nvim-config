local util = require("dupa.my_jumplist.util")
local log = require("dupa.log-mock")
-- TODO add session save
-- check what happens afte file rename
-- Problem: after file changes (adding a line) the cursor position is not correct

--- @class Tree
--- @field jumptree table
--- @field entry_comparator function
--- @field current_entry_with_index table
--- @field amount_to_skip number
--- @field debounce_timer table
--- @field Debounce_Time number
local Tree = {
  Debounce_Time = 200,
}

--- @param entry_comparator function
--- @return Tree
function Tree:new(entry_comparator)
  local obj = {
    jumptree = {},
    entry_comparator = entry_comparator,
    current_entry_with_index = nil,
    amount_to_skip = 0,
    debounce_timer = nil,
  }

  setmetatable(obj, self)
  self.__index = self

  return obj
end

function Tree:change_current_entry_to(entry, index)
  self.current_entry_with_index = { entry = entry, index = index }
end

-- TODO remove cycles
function Tree:should_push_entry(entry)
  if not entry then
    log.trace("should_push_entry: entry is nil")
    return false
  end

  if entry.file_name == "" then
    log.trace("should_push_entry: entry.file_name is empty")
    return false
  end

  if util.should_skip_file(entry.file_name) then
    log.trace("should_push_entry: skipped based on name")
    return false
  end

  if self.amount_to_skip > 0 then
    log.trace("should_push_entry: skipping entry due to amount_to_skip")
    self.amount_to_skip = self.amount_to_skip - 1
    return false
  end

  if
    self.current_entry_with_index
    and self.entry_comparator(entry, self.current_entry_with_index.entry)
  then
    log.trace("should_push_entry: entry is equal to current entry")
    return false
  end

  -- if cursor is on { 1, 0 } then its probably a mistake because ofter editor opens
  -- files on this position and then moves to correct one so we skip it
  if entry.cursor_position[1] == 1 and entry.cursor_position[2] == 0 then
    log.trace("should_push_entry: skipping entry due to start of the file")
    return false
  end

  return true
end

-- if two entries are pushed very quickly, only run the last one
--- @param function_to_debounce function
function Tree:start_debounce(function_to_debounce)
  if self.debounce_timer and not self.debounce_timer:is_closing() then
    log.trace("start_debounce: closing previous debounce")
    self.debounce_timer:close()
  end

  log.trace("start_debounce: starting new debounce")

  self.debounce_timer = vim.defer_fn(function()
    function_to_debounce()
    self.debounce_timer = nil
  end, self.Debounce_Time)
end

--- @param entry table
function Tree:push_entry(entry)
  local function push()
    if not self:should_push_entry(entry) then
      return
    end

    -- remove all entries from jumptree after current_entry_with_index index
    if self.current_entry_with_index then
      for i = #self.jumptree, self.current_entry_with_index.index + 1, -1 do
        table.remove(self.jumptree, i)
      end
    end

    self.jumptree[#self.jumptree + 1] = entry
    self:change_current_entry_to(entry, #self.jumptree)
    log.trace("pushed entry", vim.inspect(self.current_entry_with_index))
  end

  -- debouncing the push, because sometimes (e.g. after vim.lsp.buf.definition())
  -- nvim opens the file at { line: 1, column: 1 } and then immediately jumps to the
  -- location of the definition. This causes two entries to be pushed to the jumplist
  -- self:start_debounce(push)
  if entry.cursor_position[1] == 1 and entry.cursor_position[2] == 0 then
    log.trace("deferring entry due to start of the file")
    vim.defer_fn(function()
      entry = util.make_current_position_entry()
      push()
    end, 15)
  else
    push()
  end
end

--- @return table | nil
function Tree:go_back()
  if self.current_entry_with_index == nil then
    log.trace("go_back: current_entry_with_index is nil")
    return nil
  end

  local previous_entry_index = self.current_entry_with_index.index - 1

  if previous_entry_index < 1 then
    log.trace("go_back: previous_entry_index is less than 1")
    return nil
  end

  local previous_entry = self.jumptree[previous_entry_index]

  self:change_current_entry_to(previous_entry, previous_entry_index)
  log.trace("go_back with: ", vim.inspect(self.current_entry_with_index))

  return self.current_entry_with_index.entry
end

--- @return table | nil
function Tree:go_forward()
  if self.current_entry_with_index == nil then
    return nil
  end

  local next_entry_index = self.current_entry_with_index.index + 1

  if next_entry_index > #self.jumptree then
    return nil
  end

  local next_entry = self.jumptree[next_entry_index]

  self:change_current_entry_to(next_entry, next_entry_index)
  log.trace("go_forward with: ", vim.inspect(self.current_entry_with_index))

  return self.current_entry_with_index.entry
end

--- @return boolean
function Tree:is_empty()
  return #self.jumptree > 0
end

-- skips `amount` next pushes
--- @param amount number
function Tree:skip(amount)
  self.amount_to_skip = amount
end

return Tree
