local tool = require("util.lang.tool")

---@class lstrix.lang
local M = {}

M._config = {
  filetype_fallback = "_",
  tools_use_mason = true,
}

function M.setup(opts)
  vim.tbl_deep_extend("force", M._config, opts or {})
end

--- a language that requires some additional setup of tooling and needs to be
--- integrated directly with lazy.nvim
---@class lstrix.Language
---@field name lstrix.language.ix
---@field filetypes string[]
---@field mason boolean
---@field _spec table[]
local Language = {}

---@alias lstrix.language.ix string

Language.__index = Language

--- create a new language
---@param name lstrix.language.ix
---@param filetypes string | string[]
---@param opts { mason: boolean? }
function Language:new(name, filetypes, opts)
  if not filetypes then
    filetypes = { M._config.filetype_fallback }
  end
  local new = { name = name, filetypes = filetypes, _spec = {} }
  new.mason = opts.mason ~= nil and opts.mason or true

  self.__index = self
  self = setmetatable(new, self)

  return self
end

--- adds a tool to the language
---@param t lstrix.Tool
function Language:add_tool(t)
  local par = t:parameterize()

  vim.list_extend(self._spec, par)

  return self
end

function Language:server(name, ...)
  local new_tool = tool(name, {
    domain = "server",
  }, ...)

  new_tool:prepare(self)

  return self:add_tool(new_tool)
end

function Language:linter(name, ...)
  local new_tool = tool(name, {
    domain = "linter",
  }, ...)

  new_tool:prepare(self)

  return self:add_tool(new_tool)
end

function Language:formatter(name, ...)
  local new_tool = tool(name, {
    domain = "formatter",
  }, ...)

  new_tool:prepare(self)

  return self:add_tool(new_tool)
end

function Language:debugger(name, ...)
  local new_tool = tool(name, {
    domain = "debugger",
  }, ...)

  new_tool:prepare(self)

  return self:add_tool(new_tool)
end

function Language:tolazy()
  return unpack(self._spec)
end

function M.language(name, filetypes, opts)
  return Language:new(name, filetypes, opts)
end

return setmetatable(M, {
  __call = function(_, name, filetypes, opts)
    return M.language(name, filetypes, opts)
  end,
})
