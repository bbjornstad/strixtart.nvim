---@class util.memo
local M = {}

---@generic T
---@generic f: fun(...: any?): `T`?
--- very simple implementation of function memoization, no bells or whistles to
--- speak of here, just a record of the past call's return values and the
--- interception procedures.
---@param fn `f`
---@return f memoized
function M.cache(fn)
  local cache = {}

  local function wrapper(...)
    local args = { ... }

    if cache[args] ~= nil then
      return cache[args]
    end

    local new_result = fn(...)
    cache[args] = new_result

    vim.notify(vim.inspect(new_result))

    return new_result
  end
  setmetatable(cache, { __mode = "v" })

  return wrapper
end

---@generic T
---@generic f: fun(...: any?): `T`?
--- similar to memoization, but without the part where we intercept the new
--- value as replaced by the old
---@param fn `f`
---@return f recalled
function M.recall(fn)
  local results = {}

  local function wrapper(...)
    local args = { ... }

    local new_result = fn(...)

    results[args] = results[args] ~= nil and results[args] or {}
    table.insert(results[args], new_result)

    return new_result
  end
  setmetatable(results, { __mode = "v" })

  return wrapper
end

return M
