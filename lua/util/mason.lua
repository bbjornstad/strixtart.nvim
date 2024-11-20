local M = {}

local fnutil = require("util.fn")
local coalesce = fnutil.coalesce

local LOOKUP_SPEC_FIELD_MAPPING = {
  linter = {
    package = "mason-nvim-lint.mapping",
    field = "nvimlint_to_package",
    rev = "package_to_nvimlint",
  },
  formatter = {
    package = "mason-conform.mapping",
    field = "conform_to_package",
    rev = "package_to_conform",
  },
  debugger = {
    package = "mason-nvim-dap.mappings.source",
    field = "nvim_dap_to_package",
    rev = "package_to_nvim_dap",
  },
  server = {
    package = "mason-lspconfig.mappings.server",
    field = "lspconfig_to_package",
    rev = "package_to_lspconfig",
  },
}

function M.free_mason(it)
  local function try_translation(params, item)
    params = params or {}
    local has_pkg, pkg = pcall(require, params.package)
    if not has_pkg then
      return false, { err = pkg }
    end
    if not params.field and not params.rev then
      return false, { err = pkg }
    end
    local tgtfield = params.field or params.rev
    local result_container = pkg[tgtfield]
    if not result_container then
      return false, { err = pkg }
    end
    local result = result_container[item] or nil
    return result ~= nil, result
  end

  local results = require("util.fn").smap(function(dom, spec_mappings)
    local is_type_dom, result_or_error = try_translation(spec_mappings, it)
    return is_type_dom and result_or_error or false
  end, LOOKUP_SPEC_FIELD_MAPPING)

  if #results == 0 then
    return false
  end

  -- FIX: whatever we are passing through this step is not shaped correctly,
  -- check above map results
  results = require("util.fn").smap(function(segment, item)
    if not item or item[segment] ~= false or item.err ~= nil then
      return false
    end
    local res = item[segment] ~= false and segment or false
    return res
  end, results)

  local typeof = coalesce(
    results.server,
    results.linter,
    results.formatter,
    results.debugger
  )

  local res = typeof()
  return res
end

--- checks to see if a tool can be provided by mason
---@param item any?
---@return (boolean | string) use_mason, (strix.lang.Domain | boolean) mason_id_domain
function M.is_masonic(item)
  local is_masonic = M.free_mason

  local mason_type, mason_name = is_masonic(item)
  ---@cast mason_name -nil
  return mason_type ~= false and mason_name, mason_type or false
end

return M
