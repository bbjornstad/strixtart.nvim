---@diagnostic disable: unused-local

---@class util.lazy
local M = {}
local _M = {}
local _notify_mapper

--- directly accesses the given plugin's definitions as a part of lazy.nvim.
--- This provides either the table specification or a field thereof, if a field
--- is given. This function is styled in similar fashion to how the function
--- `lazyvim.util.opts` is implemented.
---@param name string plugin name/uri as a part of lazy.nvim specification.
---@param field string? name of a lazy.nvim spec field to access, if none is
---given the whole specification is returned.
---@return LazyPlugin? | any? spec the plugin's specification within
---lazy.nvim. This can be used to make adjustments.
function M.spec(name, field)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  if field == nil then
    return plugin
  end
  local Plugin = require("lazy.core.plugin")
  local ret = Plugin.values(plugin, field, false)
  return ret
end

--- does the same thing as the compose function, but inverts the operation order
--- of the given user `fn` and the pre-specified `plg` function.
---@param name string name of the lazy plugin that is targeted
---@param field string name of the field of the lazy spec that is targeted
---@param fn fun(...) a callback which will be called on the arguments to the
---preexisting plg.
---@return function fn the composed function
function M.compinvert(name, field, fn)
  local plg = M.spec(name, field)
  return function(...)
    return plg and vim.is_callable(plg) and plg(fn(...))
  end
end

--- wraps a potentially failing call or indexing of a field within an installed
--- plugin module, if the cause of failure is due to initialization
--- ordering/computed lazy ordering.
---@param name string module name, passed directly to `require` lua function.
---@param opts { field: string? } targeting options for what item within the
---specified submodule is being requested.
---@return any? result final evaluated call or indexing operation.
function M.defer(name, opts)
  opts = opts or {}

  return function(...)
    local field = opts.field

    local nf = require(name)[field]
    return not vim.is_callable(nf) and nf or nf(...)
  end
end

function M.tweeze(module, entity, modopts)
  return function(...)
    local mod = require(module)
    return mod[entity](...)
  end
end

function M.lax(module, modopts, ...)
  modopts = modopts or {}
  local subfield = modopts.item_is_subfield or false
  local wrap_args = modopts.wrapper_args or { ... }
  local function wrapper(field, ...)
    local wrapper_args = { ... }
    local mod = require(module)
    local it = field and mod[field] or mod
    return function(...)
      local args = { ... }
      if subfield then
        return it[table.concat(args, ".")]
      else
        return it(...)
      end
    end
  end
  if wrap_args ~= nil then
    return wrapper(unpack(wrap_args))
  end
end

--- simply checks the internal lazy.nvim plugin spec data objects for the given
--- plugin. This is directly ripped from where it is frequently called from in
--- lazyvim, e.g. `lazyvim.util`.
---@param plugin string plugin name to check existence of
---@return boolean has if the plugin exists.
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.info(...)
  return require("lazy.core.util").info(...)
end

function M.notify(...)
  return require("lazy.core.util").notify(...)
end

function M.error(...)
  return require("lazy.core.util").error(...)
end

function M.warn(...)
  return require("lazy.core.util").warn(...)
end

function M.debug(...)
  return require("lazy.core.util").debug(...)
end

return M
