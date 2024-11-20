local M = {}

function M.inclinate(fn, ...)
  local args = { ... }
  local f = function(props, opts)
    local wrapper
    if opts and opts.no_wrap_buffer then
      wrapper = function(g)
        return g(props, opts, unpack(args))
      end
    else
      wrapper = function(g)
        return vim.api.nvim_buf_call(props.buf, function()
          return g(props, opts, unpack(args))
        end)
      end
    end
    return wrapper(fn)
  end
  return function(props, opts)
    return pcall(f, props, opts)
  end
end

---@generic VFunc: fun(...): any
--- evaluates the given handler, under the assumption that the handler will
--- itself return a function accepting the same arguments as the original fn,
--- and uses the result as the "conjoining" operation which produces the final
--- result.
---@param fn VFunc
---@param handler fun(...): fun(fn: VFunc, ...): any
---@return VFunc wrap
function M.conjoin(fn, handler)
  local function wrap(...)
    local handle_res = handler(...)
    local ok, res = pcall(handle_res, fn, ...)
    if not ok then
      return
    end

    return res
  end

  return wrap
end

function M.invert(col, opts)
  opts = opts or {}
  local minicol = require("mini.colors")
  local clip = opts.gamut_clip or "lightness"
  local chan = opts.channel or "lightness"
  local colorspace = opts.colorspace or "hex"

  local hsl = col
  if colorspace == "hex" then
    hsl = minicol.convert(hsl, "okhsl", { gamut_clip = clip })
  end

  local inv = minicol.chan_invert(hsl, "lightness")
end

local function process_special_opts(opts)
  local spec = require("util.table").dstrip(opts, {
    condition = true,
    icon = false,
    separator = false,
    surround = { left = false, right = false },
  }, true)
  local icon = spec.icon
  local sep = spec.separator
  local surround = spec.surround
  local cond = spec.condition
  local fmtstr = "${ result }"
  fmtstr = icon and (icon .. " " .. fmtstr) or fmtstr
  fmtstr = surround.left and (surround.left .. fmtstr) or fmtstr
  fmtstr = surround.right and (fmtstr .. surround.right) or fmtstr
  fmtstr = sep and (fmtstr .. sep) or fmtstr

  return cond, fmtstr
end

local function incline_wrap(props, opts)
  local cond, fmtstr = process_special_opts(opts)

  return function(fn, ...)
    cond = vim.is_callable(cond) and cond() or cond
    if not cond then
      return nil
    end
    local fnres = fn(...)
    if fnres == nil or fnres == "" then
      return
    end

    local fin, count = fmtstr:gsub("${ result }", fnres)
    local ret = { fin }
    return ret
  end
end

function M.incline_join(fn)
  return M.conjoin(fn, incline_wrap)
end

M.Inclheir = {}
M.Inclheir.__index = M.Inclheir
---@param line table
function M.Inclheir:new(line)
  self.comps = line
  self.__index = self
  self:refresh()

  return self
end

function M.Inclheir:refresh()
  local sts = require("heirline.statusline")
  local heircomps = sts:new(self.comps)
  vim.tbl_deep_extend("keep", self, getmetatable(heircomps))

  setmetatable(heircomps, self)
end

function M.Inclheir:id_get(id)
  local items = self:eval()
  for _, i in ipairs(id) do
    items = items[i]
  end
  return items
end

function M.Inclheir:access(comp)
  comp = self:find(function(sf)
    return sf.incline_id == comp
  end)
  local id = comp.id
  local items = self:id_get(id)
  return items
end

function M.Inclheir:insert(comp)
  table.insert(self.comps, comp)
  self:refresh()
end

function M.inclheir(line, ...)
  local sts = require("heirline.statusline")
  local incline_heir = sts:new(line)
end

function M.dynscale(fn_scaling)
  if fn_scaling == "linear" then
    return function(val, factor)
      return val + val * factor
    end
  elseif fn_scaling == "exponential" then
    return function(val, factor)
      return val + val * math.exp(factor)
    end
  elseif fn_scaling == "logarithmic" then
    return function(val, factor)
      return val + val * math.log(factor)
    end
  elseif vim.is_callable(fn_scaling) then
    return function(val, factor)
      return fn_scaling(val, factor)
    end
  end
end

function M.iconset(comp, out, sep)
  if comp == nil then
    return
  end
  sep = sep or " "
  if vim.is_callable(out) then
    out = out()
  end
  if comp.icon ~= nil then
    return ("%s%s%s"):format(comp.icon, sep, out)
  end
  return out
end

function M.curmode(comp, op)
  local conds = require("heirline.conditions")
  op = op or {}
  local short = op.short or false
  local active = op.active or false
  if active then
    if not conds.is_active() then
      return "n"
    end
  end
  if short then
    return vim.fn.mode()
  else
    ---@diagnostic disable-next-line: redundant-parameter
    return vim.fn.mode(1)
  end
end

function M.colormode(comp, m)
  local utils = require("heirline.utils")
  local mode_colors = {
    n = utils.get_highlight("@function").fg,
    i = utils.get_highlight("@character").fg,
    v = utils.get_highlight("Conditional").fg,
    V = utils.get_highlight("Conditional").fg,
    c = utils.get_highlight("@constant").fg,
    ["\22"] = utils.get_highlight("@punctuation").fg,
    s = utils.get_highlight("@number.float").fg,
    S = utils.get_highlight("@number.float").fg,
    ["\19"] = utils.get_highlight("@number.float").fg,
    R = utils.get_highlight("@constant").fg,
    r = utils.get_highlight("@constant").fg,
    ["!"] = utils.get_highlight("@exception").fg,
    t = utils.get_highlight("@keyword").fg,
  }
  local md = m or comp:curmode({ short = true, active = true })
  return mode_colors[md]
end

function M.lightmode(comp, opts, m)
  local utils = require("heirline.utils")
  opts = opts or {}
  local clip = opts.gamut_clip or "cusp"
  local lighten_amount = opts.lighten or 0.2
  lighten_amount = 1 + lighten_amount
  local saturation_amount = opts.saturate or 0.2
  local minicol = require("mini.colors")
  local col = string.format(
    "#%06X",
    comp:colormode(m) or utils.get_highlight("@function").fg
  )
  local hsl = minicol.convert(col, "okhsl", { gamut_clip = clip })
  local lighter = minicol.modify_channel(hsl, "lightness", function(x)
    return (lighten_amount * (hsl.s / 60)) * x
  end, { gamut_clip = clip })
  lighter = minicol.modify_channel(lighter, "saturation", function(x)
    return saturation_amount * x
  end, { gamut_clip = clip })
  return minicol.convert(lighter, "hex", { gamut_clip = clip })
end

function M.lighten(comp, col, op)
  local clip = op.clip or "lightness"
  local lighten = op.lighten or 0.2
  local saturation = op.saturate or 0.2
  ---@type string | fun(val: number, factor: number)
  local fnscale = op.fn_scaler or "linear"
  local minicol = require("mini.colors")
  local colorspace = op.colorspace or "hex"
  if colorspace == "hex" then
    col = string.format("#%06X", col)
  end
  local hsl = minicol.convert(col, "okhsl", { gamut_clip = clip })
  fnscale = M.dynscale(fnscale)

  local lighter = minicol.modify_channel(hsl, "lightness", function(x)
    return fnscale(x, lighten)
  end)

  if colorspace == "hex" then
    lighter = minicol.convert(lighter, "hex", { gamut_clip = clip })
  end
  return lighter
end

function M.fg_complement(comp, col, op)
  local utils = require("heirline.utils")
  op = op or {}
  local light = op.light or utils.get_highlight("LspInlayHint").bg
  local dark = op.dark or utils.get_highlight("@text").fg
  local threshold = op.threshold or (0.5 * 100)
  local channel = op.channel or "lightness"
  local clip = op.clip or "lightness"

  light = vim.is_callable(light) and light(col) or light
  dark = vim.is_callable(dark) and dark(col) or dark

  if not op.noconvert then
    light = string.format("#%06X", light)
    dark = string.format("#%06X", dark)
  end

  col = type(col) ~= "string" and string.format("#%06X", col) or col
  local minicol = require("mini.colors")
  local hsl = minicol.convert(col, "okhsl", { gamut_clip = clip })
  local thischan = channel:sub(1, 1)
  if hsl[thischan] > threshold then
    return light
  end
  return dark
end

function M.slackline(opts)
  local conds = require("heirline.conditions")
  local utils = require("heirline.utils")
  opts = opts or {}
  local sts = {
    static = vim.tbl_deep_extend("force", opts.static or {}, {
      iconset = M.iconset,
      curmode = M.curmode,
      colormode = M.colormode,
      lightmode = M.lightmode,
      lighten = M.lighten,
      fg_complement = M.fg_complement,
    }),
    init = function(self)
      self.winnr = vim.api.nvim_tabpage_list_wins(0)[1]
      self.bufnr = vim.api.nvim_win_get_buf(self.winnr)
      self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    end,
  }

  return function(...)
    local args = { ... }
    if #args == 1 and type(args[1]) == "table" then
      args = args[1]
    end
    return utils.insert(sts, unpack(args))
  end
end

function M.tabname(opts)
  opts = opts or {}
end

return M
