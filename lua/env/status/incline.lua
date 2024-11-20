local bufinc = require("util.status").inclinate

local M = {}

function M.selectioncount(props, opts)
  local fn = function(p, o)
    local mode = vim.fn.mode(true)
    local lstart, cstart = vim.fn.line("v", p.win), vim.fn.col("v", p.win)
    local lend, cend = vim.fn.line(".", p.win), vim.fn.col(".", p.win)
    local line_diff = math.abs(lstart - lend) + 1
    local col_diff = math.abs(cstart - cend) + 1

    local res
    if mode:match("") then
      res = string.format("%d×%d", line_diff, col_diff)
    elseif mode:match("V") or lstart ~= lend then
      res = string.format("%d×󰟢", line_diff)
    elseif mode:match("v") then
      res = string.format("󰟢×%d", col_diff)
    else
      res = nil
    end
    return res
  end
  local f = bufinc(fn)
  local ok, result = f(props, opts)
  if not ok then
    return
  end
  return result
end

function M.searchcount(props, opts)
  local fn = function(p, o)
    return vim.fn.searchcount({ maxcount = -1, timeout = 500 })
  end
  local f = bufinc(fn)
  local ok, result = f(props, opts)
  if not ok or result == nil then
    return result
  end

  local denom = result.total or 0
  local res = string.format("%d/%d", result.current, denom)

  return res
end

function M.wrap_mode(props, opts)
  local f = bufinc(function(p, o)
    return require("wrapping").get_current_mode()
  end)
  local ok, result = f(props, opts)
  if not ok or result == "" then
    return tostring(ok) .. tostring(result)
  end
  return result
end

function M.grapple(props, opts)
  local fn = function(p, o)
    local grpl = require("grapple")
    if not grpl.exists then
      return nil
    end
    local key = grpl and grpl.statusline({ include_icon = false }) or ""
    local tag = grpl and grpl.name_or_index() or ""
    return ("%s  %s"):format(key, tag)
  end
  local f = bufinc(fn)
  local ok, result = f(props, opts)
  return ok and result
    or tostring(result)
end

function M.match_local_hl(props, opts)
  local fn = function(p, o)
    local res = require("local-highlight").match_count(p.buf)
    return res or nil
  end
  local f = bufinc(fn)
  local ok, result = f(props, opts)
  return ok and result or (tostring(ok) .. tostring(result))
end

function M.fileinfo(props, opts)
  local fn = function(p, o)
    local ftype = vim.api.nvim_get_option_value("filetype", { buf = p.buf })
    local fname = vim.api.nvim_buf_get_name(p.buf)

    local fsize = vim.fn.getfsize(fname)

    local ret = {
      vim.fn.fnamemodify(fname, ":.:t"),
      string.format("(%s: %.1f mb)", ftype, fsize / 1024),
    }

    local fstr = opts.formatter or "%s %s"
    return fstr:format(unpack(ret))
  end

  local f = bufinc(fn)
  local ok, result = f(props, opts)

  return ok and result or ok
end

function M.bufispinned(props, opts)
  local fn = function(p, o)
    local bufpin = vim.fn.exists("&winfixbuf") == 1
      and vim.api.nvim_get_option_value("winfixbuf", { win = p.win })
    return bufpin
  end

  local f = bufinc(fn)
  local ok, result = f(props, opts)
  if not ok then
    return
  end
  result = (not result and "󰤰") or "󰤱"
  return result
end

function M.trouble(props, opts)
  local fn = function(p, o)
    local trouble = require("trouble")
    local sts = trouble.statusline({
      mode = "lsp_document_symbols",
      groups = {},
      title = false,
      filter = { buf = p.buf, range = true },
      format = "{kind_icon}{symbol.name:Normal}",
      -- The following line is needed to fix the background color
      -- Set it to the lualine section you want to use
      hl_group = "lualine_c_normal",
    })
    if not sts.has() then
      return
    end
    return sts.get()
  end

  local f = bufinc(fn)
  local ok, result = f(props, opts)
  if not ok then
    return
  end
  return result
end

function M.codeium(props, opts)
  local fn = function(p, o)
    local en = require("codeium.options").options.enabled
    return en
  end

  local f = bufinc(fn)
  local ok, result = f(props, opts)

  if not ok then
    return
  end
  result = (not result and "󱋎") or "󱉔"
  return result
end

function M.diagnostics(props, opts)
  local icon =
    require("util.table").klower(require("env.ui").icons.diagnostic)
  local gethl = vim.api.nvim_get_hl
  local highlight = {
    error = gethl(0, { name = "DiagnosticError" }).fg,
    warn = gethl(0, { name = "DiagnosticWarn" }).fg,
    info = gethl(0, { name = "DiagnosticInfo" }).fg,
    hint = gethl(0, { name = "DiagnosticHint" }).fg,
  }
  local fn = function(p, o)
    local err =
      #vim.diagnostic.get(p.buf, { severity = vim.diagnostic.severity.ERROR })
    local warn =
      #vim.diagnostic.get(p.buf, { severity = vim.diagnostic.severity.WARN })
    local hint =
      #vim.diagnostic.get(p.buf, { severity = vim.diagnostic.severity.HINT })
    local info =
      #vim.diagnostic.get(p.buf, { severity = vim.diagnostic.severity.INFO })
    return { error = err, warning = warn, hint = hint, info = info }
  end

  local f = bufinc(fn)
  local ok, res = f(props, opts)
  if not ok then
    return
  end
  local fmts = {
    error = "%s %d",
    warn = "%s %d",
    hint = "%s %d",
    info = "%s %d",
  }
  local fin = {}
  for k, v in pairs(fmts) do
    local n = res[k]
    if n > 0 then
      local ret = v:format(icon[k], n)
      local hl = string.format("#%06X", highlight[k])
      table.insert(fin, { ret, ctermfg = hl, guifg = hl })
    end
  end
  return fin
end

local join = require("util.status").incline_join

return vim.tbl_map(function(s)
  return join(s)
end, M)
