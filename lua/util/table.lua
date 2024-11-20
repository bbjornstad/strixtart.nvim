local M = {}

--- separates the array/list-like portion of a mixed table from its key-value
--- associative map portion
---@param tbl table any table; this function only will have an effect on tables
---with mixed indices
---@return { [integer]: any }? listlike, { [any]: any }? maplike)
function M.unmix(tbl)
  local nums, kvs = {}, {}
  for k, v in pairs(tbl) do
    if type(k) == "number" then
      table.insert(nums, v)
    else
      kvs[k] = v
    end
  end
  return nums, kvs
end

function M.slice(tbl, start, stop)
  if start < 0 then
    start = start + #tbl
  end
  if stop < 0 then
    stop = stop + #tbl
  end

  return vim
    .iter(ipairs(tbl))
    :filter(function(i, val)
      return i >= start and i <= stop and val or false
    end)
    :totable()
end

--- produces a masking table, e.g. of the form `key` = true for the unique
--- values of the input list; dictlike input is converted to a list of values,
--- as by definition a dictlike table has unique keys, and hence this function
--- is useless
---@param tbl table | any[] input table
---@return { [any]: true } uniquely indexed set of the input table
function M.unique(tbl)
  if not vim.islist(tbl) then
    tbl = vim.tbl_values(tbl)
  end
  local res = {}
  for _, v in ipairs(tbl) do
    res[v] = true
  end
  return res
end

function M.st_unique(...)
  local stream = { ... }
  return M.unique(stream)
end

function M.l_unique(tbl)
  return vim.tbl_keys(M.unique(tbl))
end

function M.ls_unique(...)
  local tbls = { ... }
  local res = vim.iter(tbls):fold({}, function(acc, t)
    return vim.list_extend(acc, t)
  end)

  return M.unique(res)
end

---@generic T: any
---@generic S: any
---@generic mT: any
--- maps a function across the keys of a key-value table; does not adjust values
---@param fn fun(key: `T`): `mT`
---@param tbl table<`T`, `S`>
---@return table<mT, S> mapped a table of shape { [fn(key)]: value } for
---`key` and `value` from the input `tbl`
function M.kapply(fn, tbl)
  local res = {}
  for k, v in pairs(tbl) do
    res[fn(k)] = v
  end
  return res
end

--- functor version of `kapply`, e.g. returns a wrapper around the input
--- function `fn` whose evaluation on input table `tbl` gives `kapply(fn, tbl)`
---@param fn fun(key: any): any
---@return fun(in: table): table
function M.kapplicator(fn)
  return function(tbl)
    return M.kapply(fn, tbl)
  end
end

--- makes all keys of a table lowercase
---@param tbl { [string]: any }
---@return { [string]: any }
function M.klower(tbl)
  return M.kapply(string.lower, tbl)
end

--- makes all keys of a table uppercase
---@param tbl { [string]: any }
---@return { [string]: any }
function M.kupper(tbl)
  return M.kapply(string.upper, tbl)
end

--- collects the items in an iterator into a table with arbitrary keys, in
--- contrast to the standard builtin iterable method `totable` which only really
--- works with list-like maps and nothing containing actual information in the
--- keys.
---@param iter table|any[] iterable collection of things that must be gathered
---together into a single dataset.
---@return table t the collected table.
function M.miter(iter)
  return iter:fold({}, function(t, k, v)
    t[k] = v
    return t
  end)
end

--- replicates `item` into a table of `item`s; the count of final collection is
--- determined from the specified `idx`
---@param item any | fun(idx: any) item to be repeated; can be given as a
---function of the index value, expected to return the value of the inserted
---element.
---@param idx (integer | table)
---@return any[] | { [any]: any }
function M.rep(item, idx)
  vim.validate({
    idx = { idx, { "number", "table" } },
    item = { item, { "any" } },
  })

  local res = {}
  if type(idx) == "number" then
    for i = 1, idx, 1 do
      res[i] = item
    end
  else
    ---@cast idx -integer
    for _, i in pairs(idx) do
      res[i] = item
    end
  end
  return res
end

---@generic Ix: any
--- strips off the specified elements from the table. This function will access
--- the items in the table to get their values, store them appropriately, then
--- remove their indices from the original table. Used normally to prepare
--- arguments to functions at the beginning of the implementation, though this
--- is not enforced.
---@param tbl table<Ix, any> any table for which certain elements should be
---popped
---@param strip Ix | Ix[] indices of the target items to strip out of the `item`
---table
---@param defaults table<Ix, any>? a table containing optional defaults if the
---items are
---@param deepcopy boolean? whether or not the stripped item should be copied
---before assignment into the results table.
---@return table<Ix, any> subset, table<Ix, any> complement the returned table
---will be a subset of the input table, and the input table will not have the
---corresponding elements.
function M.strip(tbl, strip, defaults, deepcopy)
  local res = {}
  strip = type(strip) ~= "table" and { strip } or strip
  if defaults == nil then
    if not vim.islist(strip) then
      -- this is a dictionary that directly specifies the desired default
      -- against its searched index value, as opposed to operating separately
    end
  end
  defaults = defaults or {}
  defaults = type(defaults) == "table" and defaults or M.rep(defaults, #strip)
  deepcopy = deepcopy or false
  for _, v in ipairs(strip) do
    local this = tbl[v] or defaults[v]
    res[v] = deepcopy and vim.deepcopy(this) or this
    tbl[v] = nil
  end

  return res, tbl
end

function M.strip2(tbl, strip, deepcopy)
  strip = type(strip) ~= "table" and { strip } or strip
end

function M.dstrip(tbl, items, deepcopy)
  local res = {}
  local strip
  local input_is_list = vim.islist(items)
  if input_is_list then
    strip = items
  else
    strip = vim.tbl_keys(items)
  end

  deepcopy = deepcopy or false
  for _, v in ipairs(strip) do
    local this = tbl[v] or items[v] or nil
    res[v] = deepcopy and (this and vim.deepcopy(this)) or this
    tbl[v] = nil
  end
  return res
end

--- produces a range of integers across the given range defined by parameters
--- `start`, `stop` and 'step', with optional specificaton of a populating
--- function
---@param opts { start: integer?, stop: integer?, step: integer?, populate: fun(i: integer): any? }?
---@return integer[] | any[]
function M.range(opts)
  opts = opts or {}
  local start = opts.start or 1
  local stop = opts.stop or -1
  local step = opts.step or 1
  local populate = opts.populate or function(k)
    return k
  end
  -- in this case the starting value is larger than the ending value, which
  -- means that we need to walk down instead of up
  if start - stop > 0 then
    step = -step
  end

  local res = {}
  for i = start, stop, step do
    res[i] = populate(i)
  end
  return res
end

function M.subset(tbl)
  local mt = {
    subset = function(other)
      local res = {}
      for _, k in ipairs(other) do
        res[k] = tbl[k]
      end
      return res
    end,
  }
  return setmetatable(tbl, mt)
end

--- forces that the specified input item is of a table form, which is to say
--- that if it is a table, the item is returned unchanged, but if not, the item
--- is placed into a new table by itself. Used typically to prepare function
--- arguments that are to be operated on iterably but whose type may not
--- necessarily be iterable.
---@param item any any item that should be squished into a table if it is not
---already one.
---@param enforce_list_input boolean? if the function should fail with an error
---if the input item is not list-like. Defaults to `false`.
---@param return_empty boolean? if the function should return an empty
---table if the computed value does not represent any elements or otherwise
---fails. Defaults to `true`.
function M.tabler(item, enforce_list_input, return_empty)
  enforce_list_input = enforce_list_input or false
  return_empty = return_empty or true
  local tbl = type(item) == "table"
      and (enforce_list_input and vim.islist(item))
      and item
    or { item }
  return not return_empty and (tbl or {}) or tbl
end

function M.rget(tbl, field, sep, opts)
  local strsplit = vim.split
  opts = opts or {}
  sep = sep or "."
  local fields = strsplit(field, sep, opts)

  local operated_on = vim.deepcopy(tbl)
  if fields ~= nil then
    operated_on = vim.iter(fields):fold(operated_on, function(acc, this)
      return acc[this]
    end)
  else
    vim.notify(
      "No indexing field given, returning entire table...",
      vim.log.levels.WARN
    )
  end
  return operated_on
end

--- converts a list-like table into a table whose keys are the corresponding
--- list items and the value is their ordering; essentially just a reversing of
--- keys and values.
---@param tbl table list like collection
---@return table { [any]: integer }
function M.idxlist(tbl)
  local res = {}
  for i, v in pairs(tbl) do
    res[v] = i
  end
  return res
end

function M.zip(indexer, values)
  local res = {}
  for i, v in ipairs(indexer) do
    local new_idx = indexer[i]
    local new_val = values[new_idx] or values[i]
    res[new_idx] = new_val
  end
  return res
end

---@generic Axis: table
--- creates a handler which accepts a function operating over a certain feature
--- element of the given table, and effectively maps the input function along
--- the chosen axis. Generally a thin wrapper around calls to vim standard
--- library iterable operation functions, but with some additional conveniences
--- to make this a bit more helpful
---@param tbl table any table type could theoretically use this function. Most
---often, this will be hidden away behind a method-invocation syntax using a
---`:`. But this is not strictly necessary, and this function can be called
---directly on the table and indexer directly from the module.
---@param idxr `Axis` reference to an `axis` of the table `tbl`. Note that this
---can be
---@return fun(fn: (fun(...: any?): any?), ...: any?)
function M.per(tbl, idxr)
  return function(fn, ...)
    local args = { ... }
    local idx = vim.iter(idxr)
    idx:map(function(k, v)
      -- there are really two possibilities here, either we are iterating over a
      -- list-like item in which case,
      return fn(v, unpack(args))
    end)
  end
end

--- turns a table inside out, e.g. keys become values and values become keys,
--- but with special operation on the list-like portion of a certain tables in the
--- following way: key,value pairs where the value is simply the boolean `true`
--- become list-like indexed where the value is the preceding key. key,value
--- pairs where the key is an integer become indexed entries where the value is
--- simply the boolean `true`. This behavior allows for a list of elements to be
--- turned into an identity-mapping ({ [any]: true } type associative array)
---@param tbl { [any]: any } | { [integer]: any } | { [any]: true }
---@return { [any]: any } | { [any]: true } | { [integer]: any } inverted
function M.invert(tbl)
  local cur_idx = 0
  local res = vim
    .iter(pairs(tbl))
    :map(function(k, v)
      cur_idx = cur_idx + 1
      local new_k, new_v
      if type(v) == "boolean" then
        new_k = cur_idx
      else
        new_k = v
      end
      if type(k) == "number" then
        new_v = true
      else
        new_v = k
      end
      return { [new_k] = new_v }
    end)
    :totable()

  return vim.tbl_extend("force", {}, unpack(res))
end

---@generic T: table
--- removes entries from a mapping, returning a copy of the original table with
--- matching entries deleted
---@param tbl `T`
---@param idxs any[]
---@return T subset
function M.drop(tbl, idxs)
  local cp = vim.deepcopy(tbl)
  idxs = type(idxs) == "table" and idxs or { idxs }

  for _, idx in ipairs(idxs) do
    cp[idx] = nil
  end

  return cp
end

function M.attr_filter(items, attr)
  attr = attr or {}

  local predicated = vim.iter(items):filter(function(item, val)
    return vim.iter(attr):all(function(attr_id, attr_val)
      if vim.is_callable(attr_val) then
        return attr_val(item, val)
      end
      return item[attr_id] == attr_val
    end)
  end)
  return predicated:totable()
end

function M.extend(this, that)
  for k, v in pairs(that) do
    this[#this + 1] = v
  end
  ---@type table
  return this
end

return M
