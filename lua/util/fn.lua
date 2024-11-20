---@module "util.fn" utilities for wrapping and manipulating function valued
---items.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class ix<T>: any

--- a collection of utilities that are related to functors acting as a wrap over
--- other functions, in order to enhance the behavior of those wrapped
--- functions. Some of the other `util` utilities also fit this description
--- but may be in a more specific submodule if the domain fits.
---@class util.fn
local M = {}

-- library imports
local OSet = require("util.orderedset")

---@generic K, V, T
--- a version of the map function, e.g. vim.tbl_map, but with the possibility to
--- also use the assigned data belonging to the key. A key-value iterative map
--- process.
---@param fn fun(key: K, value: V): T? function applied to each key-element
---pairing
---@param tbl { [K]: V } any table to apply the given `fn` elementwise
---@param ... any[] any additional arguments to pass to the function
---@return { [K]: T }? result table with the function applied to each
---key-value pair.
function M.smap(fn, tbl, ...)
  local extra_args = { ... }
  local iter
  if vim.islist(tbl) then
    iter = vim.iter(ipairs(tbl))
  else
    iter = vim.iter(tbl)
  end
  local res = iter
    :fold(function(acc, key, value)
      local res = fn(key, value, unpack(extra_args))
      acc[key] = res
      return acc
    end)
    :totable()

  res = vim.tbl_deep_extend("force", {}, {}, unpack(res))
  return res
end

--- wraps a function of a a single variable such that it can operate on an
--- interable collection of such input variables as well as the single variable.
--- In other words, given an input function f(var: any): any?, allows the
--- operation of f across iterable collections of var, e.g. by returning a
--- function f'(var: any|any[]): any?
---@param fn fun(var: any, ...): any? a function that accepts at least a single
--- argument, which will be wrapped to accept a collection of such `var`
---@param as_method boolean? a flag that indicates whether or not the function
--- being wrapped is called using a typical method syntax; this is required to
--- safely handle the method case since it is normally assumed that the first
--- variable (which would correspond to `self` in a method) is the argument which
--- is supposed to be recursed over.
---@return fun(var: any|any[], ...): any? fn the new wrapped function, which can
--- accept the collection form of `var`
function M.recurser(fn, as_method)
  local recurser_wrap
  as_method = as_method or false
  if as_method then
    recurser_wrap = function(cls, collection, ...)
      local args = { ... }
      if not type(collection) == "table" then
        return fn(cls, collection, unpack(args))
      end
      local res = M.smap(function(idx, collitem)
        return fn(cls, collitem, unpack(args))
      end, collection)

      -- res = vim.tbl_deep_extend("force", {}, {}, unpack(res))

      return res
    end
  else
    recurser_wrap = function(collection, ...)
      local args = { ... }
      if not type(collection) == "table" then
        return fn(collection, unpack(args))
      end
      local res = M.smap(function(idx, collitem)
        return fn(collitem, unpack(args))
      end, collection)
      -- res = vim.tbl_deep_extend("force", {}, {}, unpack(res))

      return res
    end
  end

  return recurser_wrap
end

---@generic K, V
--- handles "rezipping" of slices out of their constitutent table parent items.
---@param arguments table<K, V>[] any set of arbitrarily sized tables, whose
--- elements should be unpacked slice-wise.
---@return table<K, V[]> list containing a slice of each table at the top-level
function M.rezip(arguments)
  local res = {}
  local indices = vim.iter(vim.iter(arguments):map(function(val)
    return vim.tbl_keys(val)
  end))
  local idxset = indices:fold(OSet.new({}), function(agg, k, val)
    agg = agg:intersect(val)
    return agg
  end)

  for _, idx in pairs(idxset) do
    res[idx] = vim.iter(arguments):map(function(val)
      return val[idx]
    end)
  end
  return res
end

---@generic T
--- the simplest possible function that can accept arbitrary arguments and does
--- absolutely nothing. this mainly exists when we need a random function to
--- latch onto for other reasons and lack a convenient option with better
--- semantic meaning, or as the "null" result for parameters that expect
--- function values.
---@param ... T[] these exist purely for compatibility with other functions
function M.eff(...) end

---@generic T
--- the simplest possible function accepting arbitrary arguments with full
--- information flow through the wrapper, e.g. the function returns the raw set
--- of varargs given as arguments. This mainly exists when we need a random function to
--- latch onto for other reasons and lack a convenient option with better
--- semantic meaning, or as the "null" result for parameters that expect
--- function values, but specifically for code contexts where there are output
--- values expected corresponding to the number of input values.
---@param ... T these exist purely for compatibility with other functions, and
--- are returned from `F` unaltered.
---@return T ...
function M.F(...)
  return ...
end

function M.taccessor(tbl, nested)
  nested = nested ~= nil and nested or false
  local mt = {
    __call = function(t, ...)
      if nested then
        local res = tbl
        for _, v in ipairs({ ... }) do
          res = res[v]
        end
        return res
      end
      local fn = M.recurser(function(it)
        return tbl[it]
      end)
      return fn({ ... })
    end,
  }

  return setmetatable(tbl, mt)
end

--- given a table valued function, returns a wrapper which automatically unwraps
--- the evaluated results to give the contained element when the results are a
--- list containing a single element, and the full collection otherwise
---@param fn fun(...): table any function whose output is a table
---@return fun(...): table | any wrap
function M.singlet(fn)
  return function(...)
    local res = fn(...)
    return #res == 1 and res[1] or res
  end
end

function M.resolve(fn)
  return function(...)
    local res = fn(...)
    if vim.is_callable(res) then
      return M.resolve(res)(...)
    end
    return res
  end
end

---@generic T
---@generic S
--- creates a function which sequentially evaluates a series of functions
--- specified as an array argument
---@param fns (fun(...: T?): S[]?)[]
---@return fun(...: T?): S?
function M.multievaluator(fns)
  return function(...)
    local args = { ... }
    fns = M.smap(function(fn)
      if not fn then
        require("util.newts").warn(
          [[
        Function was not evaluated due to being nil
        %s, args: %s
        ]],
          fns,
          args
        )
        return
      end
      return fn(unpack(args))
    end, fns)
    return fns
  end
end

--- produces an iterator over a table item which has been optionally
--- pre-filtered with arbitrary input predicates; this version returns the
--- underlying Iterator created with `vim.iter`
---@param tbl table
---@param ... fun(key, val): boolean
---@return vim.iter iter
function M.nvfit(tbl, ...)
  local fargs = { ... }
  local iter = vim.iter(tbl):filter(function(tk, tv)
    return vim.iter(fargs):all(function(f)
      return f(tk, tv)
    end)
  end)

  return iter
end

---@generic T
--- produces an iterator over a table item which has been optionally
--- pre-filtered with arbitrary input predicates; this version returns the
--- underlying Iterator created with `vim.iter`
---@param tbl { [any]: `T` }
---@param ... fun(key, val): boolean
---@return fun(): `T`?
function M.fit(tbl, ...)
  local iter = M.nvfit(tbl, ...)

  return function()
    return iter:next()
  end
end

--- creates a function which sequentially evaluates a series of functions passed
--- as input arguments
---@param ... fun(...: any?): any?
---@return fun(...: any?): any?
function M.exp_multievaluator(...)
  local fns = table.pack(...)

  return M.multievaluator(fns)
end

function M.descale(fn)
  return function(scalar, ...)
    local this_res = fn(...)
    if scalar then
      return vim.tbl_values(this_res)[1]
    end
  end
end

--- this function accepts a series of expressions as variable arguments and
--- successively evaluates them until the expression is `true` or no inputs
--- remain
---@param ... any?
---@return fun(...: any?): any?
function M.coalesce(...)
  local fns = { ... }
  fns = vim.iter(fns):map(function(fn)
    return vim.is_callable(fn) and fn or function()
      return fn
    end
  end)
  return function(...)
    for _, v in ipairs(fns) do
      local ok, res = pcall(v, ...)
      if ok == true then
        return res
      end
    end
  end
end

function M.inject(fn, inj)
  inj = inj or {}
  local env = getfenv(fn)
  env = vim.tbl_deep_extend("force", env, inj)
  setfenv(fn, env)
end

function M.wraparg(fn, ...)
  local argmod = { ... }
  return function(...)
    local callargs = { ... }
    local args = vim
      .iter(ipairs(argmod))
      :map(function(i, mod)
        return mod(callargs[i])
      end)
      :totable()
    return fn(unpack(args))
  end
end

function M.indexer(...)
  local args = { ... }
  return function(item)
    if #args == 0 then
      return item
    end
    return vim.tbl_get(item, unpack(args))
  end
end

function M.tbl_set(tbl, value, ...)
  local args = { ... }
  local joined = table.concat(args, ".")
  local temp = vim.defaulttable()
  temp[joined] = value

  local first = vim.iter(args):peek()
  tbl[first] = vim.tbl_extend("force", tbl[first] or {}, temp)
end

return M
