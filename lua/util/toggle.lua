local ntc = require("util.newts")

local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[2]
    else
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[1]
      return ntc.info(
        "Set " .. option .. " to " .. vim.opt_local[option]:get(),
        { title = "Option" }
      )
    end
    ---@diagnostic disable-next-line: no-unknown
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if not silent then
      if vim.opt_local[option]:get() then
        ntc.info("Enabled " .. option, { title = "Option" })
      else
        ntc.warn("Disabled " .. option, { title = "Option" })
      end
    end
  end
end

function M.toggler(cb, initial_state)
  local toggle_state = initial_state or false
end

local nu = { number = true, relativenumber = true }
--- toggles line numbers
function M.number()
  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    nu = {
      number = vim.opt_local.number:get(),
      relativenumber = vim.opt_local.relativenumber:get(),
    }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    ntc.warn("Disabled line numbers", { title = "Option" })
  else
    vim.opt_local.number = nu.number
    vim.opt_local.relativenumber = nu.relativenumber
    ntc.info("Enabled line numbers", { title = "Option" })
  end
end

--- toggles diagnostic output
function M.diagnostics(buf)
  buf = buf or 0
  local new_state = not vim.diagnostic.is_enabled(buf)
  vim.diagnostic.enable(new_state, { buf = buf })
  if new_state then
    ntc.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    ntc.warn("Disabled diagnostics", { title = "Diagnostics" })
  end
end

--- toggles use of inlay hints
---@param buf? number
---@param value? boolean
function M.inlay_hints(buf, value)
  buf = buf or 0
  local ih = vim.lsp.inlay_hint
  local new_state = value or not ih.is_enabled({ buf = buf })
  ih.enable(new_state, { buf = buf })
  if new_state then
    ntc.info("Enabled inlay hints in buffer: " .. buf)
  else
    ntc.warn("Disabled inlay hints in buffer: " .. buf)
  end
end

local focus_enabled = true
--- toggles use of focus.nvim automatic windowing layout
---@param buf? integer bufnr identifer
function M.focus(buf)
  buf = buf or 0
  focus_enabled = not focus_enabled
  if not focus_enabled then
    vim.b[buf].focus_disable = true
    ntc.warn("Disabled focus windowing")
  else
    vim.b[buf].focus_disable = false
    ntc.info("Enabled focus windowing")
  end
end

--- given a callback argument whose purpose is to toggle an option or plugin
--- setting, this will return a function of matching signature for the proper
--- notification of the state of that setting. Allows for the user to specify
--- particular behavior for computation of setting state and notification
--- message if desired.
---@param cb fun(...): any? a function which will result in the appropriate
---setting adjustment behavior when it is evaluated. The signature of this
---function determines the signature of the returned wrapper. Can return a
---value, in which case it will be used as the resultant computed state if the
---`state` callback parameter is not provided.
---@param state? fun(...): any? a function which will result in the appropriate
---computation of the new state when evaluated with the same arguments as the
---`cb` parameter. If this value is nil, the result of the computation of the
---`cb` parameter is used instead.
---@param msgfmt? fun(result: string): string a function of a single value, the
---result of the state computation, which returns the formatted notification
---message. Defaults to `vim.inspect`.
function M.with_notice(cb, state, msgfmt)
  msgfmt = msgfmt or vim.inspect
  return function(...)
    local state_res = state and state(...)
    local cb_res = cb(...)
    local ret_res = state_res or cb_res
    vim.notify(msgfmt(ret_res))
    return ret_res
  end
end

local bufpin = false
function M.bufferpin(win)
  if vim.fn.exists("&winfixbuf") == 1 then
    local state = vim.api.nvim_get_option_value("winfixbuf", { win = win or 0 })
      or bufpin
    local invstate = not state
    vim.api.nvim_set_option_value("winfixbuf", invstate, { win = win or 0 })
    if invstate then
      ntc.info("Enabled buffer pin in window: " .. (win or 0))
    else
      ntc.warn("Disabled buffer pin in window: " .. (win or 0))
    end
  else
    ntc.warn("native window buffer pinning not available...")
  end
end

setmetatable(M, {
  __call = function(m, ...)
    return m.option(...)
  end,
})

return M
