local TOOL_TOPOLOGY = require("env.lsp")

--- an interface wrapping a single language support tool, e.g. a linter, a
--- formatter, etc.
---@class lstrix.Tool
--- name of the tool
---@field name lstrix.tool.ix
--- domain of the tool, e.g. server, linter, formatter, debugger, or other
---@field domain? lstrix.Domain
--- whether the tool should be handled using mason.nvim and associated tools
---@field mason? lstrix.mason.Enable
--- templates that should be used to parameterize this tool
---@field templates? table[]
local Tool = {}

---@alias lstrix.tool.ix string

Tool.__index = Tool

---@alias lstrix.tool.attr string

--- create a new tool
---@param name lstrix.tool.ix
---@param ... { [lstrix.tool.attr]: any }
function Tool:new(name, ...)
  local new = vim.tbl_deep_extend("force", {}, {
    name = name,
  }, ...)

  self.__index = self
  self = setmetatable(new, self)
  return self
end

---@alias lstrix.Domain
---| 'server'
---| 'linter'
---| 'formatter'
---| 'debugger'
---| 'other'

---@alias lstrix.mason.Enable
---| boolean
---| fun(): boolean

--- retrieves the standard set of parameterizations for tools of the specified
--- domain and mason status
---@param domain lstrix.Domain
---@param mason lstrix.mason.Enable
local function get_parameterizations(domain, mason)
  local pars = {}
  local domain_top = TOOL_TOPOLOGY[domain]

  -- these are all the things that should be evaluated when mason status is not
  -- relevant for that tool
  if domain_top and domain_top._ then
    vim.list_extend(pars, vim.deepcopy(domain_top._) or {})
  end

  -- now we can separate mason and nonmason items for tools where this is a
  -- relevant piece of information local masonish = domain_top[mason and "mason"]
  local masonish = domain_top[mason and "mason"] or false
  local nonmasonish = domain_top[not mason and "nonmason"] or false

  vim.list_extend(pars, masonish and vim.deepcopy(masonish) or {})
  vim.list_extend(pars, nonmasonish and vim.deepcopy(nonmasonish) or {})

  return pars
end

---@param lang lstrix.Language
function Tool:prepare(lang)
  -- determine mason status based on tool and language settings

  self.mason = (lang.mason and self.mason ~= false and self.mason)
    or (self.mason == true and self.mason)
    or true
  self.language = lang

  -- get the relevant template(s) from TOOL_TOPOLOGY

  self.templates = get_parameterizations(self.domain, self.mason)
end

---@class lstrix.tool.Topology

--- resolves a parameter specification into the appropriately shaped and behaved
--- function that operates on lazy.nvim spec items
---@param param lstrix.tool.Topology
---@param extend_with (fun(this, that): table)?
function Tool:resolve(param, extend_with)
  extend_with = extend_with
    or function(this, that)
      return vim.tbl_deep_extend("force", this, that)
    end
  local spec = vim.deepcopy(param)
  local valid_fields = { "opts", "keys", "dependencies", "cmd", "event", "ft" }
  local f_factory = function(vfield)
    if not spec or not spec[vfield] then
      return
    end

    local f = function(_, lazyopts)
      vim.print(lazyopts)
      for optname, optval in pairs(spec[vfield]) do
        local lazyval = lazyopts[optname] or false
        if lazyval then
          local opttype = type(lazyval)

          if opttype == "function" then
            lazyopts[optname] = function(...)
              optval(self, lazyval(...))
            end
          elseif opttype == "table" then
            optval(self, lazyopts[optname])
          else
            require("util.newts").warn(
              [[
            Schematic specifies that lstrix tool configuration is only valid for tables and functions
            Item %s of type %s was found instead
            ]],
              lazyval,
              opttype
            )
            return
          end
        else
          lazyopts[optname] = {}
          optval(self, lazyopts[optname])
        end
      end
    end

    return f
  end

  local freshspec = vim.iter(valid_fields):fold({}, function(acc, field)
    acc[field] = f_factory(field)
    return acc
  end)
  freshspec[1] = spec[1]

  vim.print(freshspec)

  -- vim.tbl_deep_extend("force", spec, freshspec)

  return freshspec
end

function Tool:parameterize()
  local fin = vim
    .iter(self.templates)
    :map(function(parspec)
      return self:resolve(parspec)
    end)
    :totable()

  return fin
end

local function tool(name, ...)
  return Tool:new(name, ...)
end

return tool
