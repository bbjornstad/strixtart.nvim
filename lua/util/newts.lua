local M = {}

M._config = {}

function M.setup(opts)
  M._config = vim.tbl_deep_extend("force", M._config, opts or {})
end

---@type { [string]: vim.diagnostic.Severity }
M.severity = vim.diagnostic.severity

--- send an info message
---@param message string
---@param ... any
function M.info(message, ...)
  local nargs = select("#", ...)

  if nargs > 0 then
    message = string.format(
      message,
      unpack(vim
        .iter({ ... })
        :map(function(v)
          v = type(v) == "string" and v or vim.inspect(v)
          return v
        end)
        :totable())
    )
  end

  vim.notify(message, M.severity.INFO)
end

--- send a warning message
---@param message string
---@param ... any
function M.warn(message, ...)
  local nargs = select("#", ...)

  if nargs > 0 then
    message = string.format(
      message,
      unpack(vim
        .iter({ ... })
        :map(function(v)
          v = type(v) == "string" and v or vim.inspect(v)
          return v
        end)
        :totable())
    )
  end

  vim.notify(message, M.severity.WARN)
end

--- send an error/exception message
---@param message string
---@param ... any
function M.error(message, ...)
  local nargs = select("#", ...)

  if nargs > 0 then
    message = string.format(
      message,
      unpack(vim
        .iter({ ... })
        :map(function(v)
          v = type(v) == "string" and v or vim.inspect(v)
          return v
        end)
        :totable())
    )
  end
  vim.notify(message, M.severity.ERROR)
end

--- send a hint message
---@param message string
---@param ... any
function M.hint(message, ...)
  local nargs = select("#", ...)

  if nargs > 0 then
    message = string.format(
      message,
      unpack(vim
        .iter({ ... })
        :map(function(v)
          v = type(v) == "string" and v or vim.inspect(v)
          return v
        end)
        :totable())
    )
  end

  vim.notify(message, M.severity.HINT)
end

return M
