local M = {}

local function utils()
  if M._utils == nil then
    M._utils = require("heirline.utils")
  end

  return M._utils
end

local function conds()
  if M._conds == nil then
    M._conds = require("heirline.conditions")
  end

  return M._conds
end
local heirhl = utils().get_highlight

function M.modeular_transform(fn, opts)
  local pred = opts.predicate or function(mode)
    return true
  end
  local f = function(comp, op, m)
    op = op or {}
    m = m or comp:curmode()
    return fn(comp, op)
  end
end

local MODE_DEPENDENT_HSL_BASE_TRANSFORM = { saturate = 0.72, lighten = 1.06 }

M.SEPARATORS = vim.tbl_deep_extend("force", {
  subsection = "┊",
  spacer = " ",
  top = {
    right = "",
    left = "",
    xright = "",
    xleft = "",
  },
  bottom = {
    right = "",
    left = "",
    xleft = "",
    xright = "",
  },
  incline = {
    left = "⌈",
    right = "⌉",
  },
  midsection = {
    left = "⌈",
    right = "⌋",
  },
  section = {
    left = "",
    right = "",
  },
  mode_delim = {
    left = "󰩀",
    right = "󰨿",
  },
}, require("env.ui").statusline_custom_separators or {})

M.align = {
  provider = "%=",
  hl = function(self)
    return { fg = "status_bg", bg = "status_bg" }
  end,
}

local function spacer(n, sep)
  sep = sep or ""
  n = n or 1
  return {
    provider = function(self)
      return string.rep(" ", n, sep)
    end,
  }
end

M.spacer = spacer(1)

function M.flexcap(opts)
  opts = opts or {}
  local sep = opts.sep
  local hl = opts.hl
    or function(self)
      return {
        bg = "status_bg",
        fg = self:colormode(),
      }
    end
  return {
    init = function(self)
      self.sep = sep
    end,
    provider = function(self)
      return self.sep
    end,
    hl = hl,
  }
end

local cterm_attr = {
  "bold",
  "underline",
  "undercurl",
  "underdouble",
  "underdotted",
  "underdashed",
  "strikethrough",
  "reverse",
  "inverse",
  "italic",
  "standout",
  "altfont",
  "nocombine",
}

local function hltr(spec, opts)
  opts = opts or {}
  local ut = require("heirline.utils")
  return function(self)
    local res = {}
    for k, v in pairs(spec) do
      if not vim.tbl_contains(cterm_attr, k) then
        local hlres = ut.get_highlight(v)[k]
        res[k] = hlres ~= nil and hlres or v
      else
        res[k] = v
      end
    end
    return res
  end
end

---@alias SeparatorColor
---| string
---| fun(self): string

---@alias Separator
---| string
---| fun(self): string

---@class SeparatorSpec
---@field style? "default"
---@field bg? SeparatorColor | { left: SeparatorColor, right: SeparatorColor }
---@field fg? SeparatorColor | { left: SeparatorColor, right: SeparatorColor }
---@field corner? "bottom-left" | "bottom-right" | "top-left" | "top-right"
---@field chars? Separator | { left: Separator, right: Separator }
---@field exclude? { left: boolean, right: boolean }
---@field cterm_attr? { left: string, right: string }
---@field condition? allBoolean

---@param opts SeparatorSpec
function M.transition_separator(opts)
  local excl = opts.exclude or { left = false, right = false }
  local corner = opts.corner or "bottom-left"
  local fg = opts.fg or function(self)
    return self:colormode()
  end
  local bg = opts.bg or function(self)
    return self:colormode()
  end

  fg = type(fg) == "table" and fg or { left = fg, right = fg }
  bg = type(bg) == "table" and bg or { left = bg, right = bg }

  local noncolor_hl_attr = opts.cterm_attr or {}

  ---@alias allBoolean
  ---| { left: boolean, right: boolean }
  ---| fun(self): boolean
  ---| fun(self): { left: boolean, right: boolean }
  ---| { left: fun(self): boolean, right: fun(self): boolean }

  ---@type allBoolean
  local cond = opts.condition or function(self)
    return true
  end
  cond = type(cond) ~= "table" and { left = cond, right = cond } or cond

  local chars = (
    corner == "bottom-left"
    and { left = M.SEPARATORS.bottom.left, right = M.SEPARATORS.bottom.right }
  )
    or (corner == "bottom-right" and {
      left = M.SEPARATORS.bottom.xleft,
      right = M.SEPARATORS.bottom.xright,
    })
    or (corner == "top-left" and {
      left = M.SEPARATORS.top.left,
      right = M.SEPARATORS.top.right,
    })
    or (
      corner == "top-right"
      and { left = M.SEPARATORS.top.xright, right = M.SEPARATORS.top.xleft }
    )
  if not chars then
    require("util.newts").warn(
      "Could not construct separators with spec \n" .. vim.inspect(opts)
    )
    return
  end
  local res = {
    not excl.left and {
      static = { char = chars.left },
      provider = function(self)
        return self.char
      end,
      hl = function(self)
        local leftfg = fg.left
        local leftbg = bg.left
        local thisfg = (vim.is_callable(leftfg) and leftfg(self))
          or (not vim.is_callable(leftfg) and leftfg)
          or nil
        local thisbg = (vim.is_callable(leftbg) and leftbg(self))
          or (not vim.is_callable(leftbg) and leftbg)
          or nil
        return vim.tbl_deep_extend(
          "force",
          { fg = thisfg, bg = thisbg },
          noncolor_hl_attr
        )
      end,
      condition = cond.left,
    } or nil,
    not excl.right and {
      static = { char = chars.right },
      provider = function(self)
        return self.char
      end,
      hl = function(self)
        local rightfg = fg.right
        local rightbg = bg.right
        local thisfg = (vim.is_callable(rightfg) and rightfg(self))
          or (not vim.is_callable(rightfg) and rightfg)
          or nil
        local thisbg = (vim.is_callable(rightbg) and rightbg(self))
          or (not vim.is_callable(rightbg) and rightbg)
          or nil
        return vim.tbl_deep_extend(
          "force",
          { fg = thisfg, bg = thisbg },
          noncolor_hl_attr
        )
      end,
      condition = cond.right,
    } or nil,
  }
  return unpack(res)
end

local mode = {}

mode.identifier = {
  utils().surround(
    { M.SEPARATORS.mode_delim.left, M.SEPARATORS.mode_delim.right },
    nil,
    {
      provider = function(self)
        return (" %s %.8s"):format(
          self.mode_id[self.mode],
          self.icons[self.mode:sub(1, 1):lower()]
        )
      end,
    }
  ),
}

mode.icon = {
  M.spacer,
  {
    provider = function(self)
      return self.icons[self.mode]
    end,
  },
  M.spacer,
}

M.modicon = {
  static = {
    icons = require("env.ui").icons.statusline.heir_mode,
  },
  init = function(self)
    self.mode = self:curmode({ short = false, active = true })
  end,
  hl = function(self)
    return {
      fg = "status_bg",
      bg = self:colormode(),
      bold = true,
    }
  end,
  utils().surround(
    { M.SEPARATORS.spacer, M.SEPARATORS.top.right },
    nil,
    mode.icon
  ),
}

M.mode = {
  hl = function(self)
    return {
      fg = "status_bg",
      bg = "status_bg",
      bold = true,
    }
  end,
  static = {
    icons = require("env.ui").icons.statusline.heir_mode,
    mode_id = {
      n = "normal",
      no = "normal*",
      nov = "normal*",
      noV = "normal*",
      ["no\22"] = "normal*",
      niI = "~insert",
      niR = "~replace",
      niV = "~virt",
      nt = "~term",
      v = "visual",
      vs = "#select",
      V = "visual|",
      Vs = "#select|",
      ["\22"] = "vblock",
      ["\22s"] = ".#vblock",
      s = "select",
      S = "select|",
      ["\19"] = "select%",
      i = "insert",
      ic = "insert@",
      ix = "insert@",
      R = "replace",
      Rc = "replace@",
      Rx = "replace@",
      Rv = "virt",
      Rvc = "virt@",
      Rvx = "virt@",
      c = "editcmd",
      cv = "ex",
      r = "hitenter",
      rm = "more",
      ["r?"] = "confirm",
      ["!"] = "shell",
      t = "term",
    },
  },
  init = function(self)
    self.mode = self:curmode({ short = false, active = true })
  end,
  utils().surround(
    { "", M.SEPARATORS.bottom.left },
    function(self)
      return self:colormode()
    end,
    utils().surround({
      M.SEPARATORS.spacer,
      M.SEPARATORS.spacer,
    }, nil, { mode.identifier, M.spacer })
  ),
  M.transition_separator({
    corner = "bottom-left",
    exclude = { left = true, right = false },
    fg = {
      left = function(self)
        return self:colormode()
      end,
      right = function(self)
        return self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM)
      end,
    },
    bg = {
      left = function(self)
        return "status_bg"
      end,
      right = function(self)
        return "status_bg"
      end,
    },
    condition = { right = conds().is_git_repo },
  }),
}

local file = {}

file.name = {
  provider = function(self)
    local filename = self.filename
    filename = filename == "" and "--- none ---"
      or vim.fn.fnamemodify(filename, ":.")
    return filename
  end,
}

file.icon = {
  init = function(self)
    local extension = vim.fn.fnamemodify(self.filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
      self.filename,
      extension,
      { default = true }
    )
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

file.format = {
  provider = function(self)
    local fmt = vim.bo.fileformat
    return fmt ~= "unix" and ("[ %s ]"):format(fmt)
  end,
}

file.type = {
  provider = function(self)
    return vim.bo[self.bufnr].filetype
  end,
}

file.encoding = {
  provider = function(self)
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= "utf-8" and enc:upper()
  end,
}

file.size = {
  provider = function(self)
    -- stackoverflow, compute human readable file size
    local suffix = { "b", "k", "M", "G", "T", "P", "E" }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(self.bufnr))
    fsize = (fsize < 0 and 0) or fsize
    if fsize < 1024 then
      return fsize .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
  end,
}

file.last_modified = {
  condition = function(self)
    self.mod = vim.fn.getftime(vim.api.nvim_buf_get_name(self.bufnr))
    return self.mod ~= nil
  end,
  { provider = "󱇨" },
  M.spacer,
  {
    -- did you know? Vim is full of functions!
    provider = function(self)
      return (self.mod > 0)
        and ("(%s)"):format(os.date("%Y-%m-%d %H:%M:%S", self.mod))
    end,
  },
}

---@class environment.status.component.file
M.file = utils().insert(
  {
    init = function(self)
      self.modified = vim.bo.modified
    end,
    hl = function(self)
      return {
        fg = "status_fg_dim",
        bg = "status_bg",
        italic = true,
      }
    end,
  },
  file.icon,
  M.spacer,
  utils().insert({
    hl = function(self)
      return {
        fg = heirhl("@namespace").fg,
        bg = "status_bg",
      }
    end,
  }, file.name),
  M.spacer,
  file.last_modified
)

local astrolabe = {}

astrolabe.ruler = {
  static = { icon = "󱋫" },
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = function(self)
    return self:iconset([[%l/%L ≅ %3P]])
  end,
}

astrolabe.gauge = {
  init = function(self)
    self.lines = vim.api.nvim_buf_line_count(self.bufnr)
    self.current_line, self.current_row =
      unpack(vim.api.nvim_win_get_cursor(self.winnr))
    self.this_loc = (self.current_line - 1) / self.lines
  end,
  static = {
    -- sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
    -- Another variant, because the more choice the better.
    sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
  },
  provider = function(self)
    -- local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    -- local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor(self.this_loc * #self.sbar) + 1
    return self:iconset(self.sbar[i]) or nil
  end,
}

M.labe = {
  init = function(self)
    self.lines = vim.api.nvim_buf_line_count(self.bufnr)
    self.current_line, self.current_row =
      unpack(vim.api.nvim_win_get_cursor(self.winnr))
    self.this_loc = (self.current_line - 1) / self.lines
  end,
  hl = function(self)
    if self.this_loc > 0.8 then
      return {
        bg = "status_bg",
        fg = heirhl("@variable.builtin").fg,
      }
    else
      return {
        bg = "status_bg",
        fg = heirhl("@variable.parameter").fg,
      }
    end
  end,
  utils().surround(
    {
      M.SEPARATORS.section.right,
      M.SEPARATORS.section.right,
    },
    nil,
    {
      M.spacer,
      astrolabe.ruler,
      M.spacer,
      astrolabe.gauge,
      M.spacer,
    }
  ),
}

local git = {}

git.branch = {
  static = {
    icon = "",
  },
  hl = function(self)
    return {
      fg = "diagnostic_info",
      italic = true,
    }
  end,
  provider = function(self)
    return self:iconset(vim.b.gitsigns_status_dict.head)
  end,
}

git.spacer = {
  { provider = " ⧰ ", hl = { fg = "status_fg" } },
}

git.modifications = {
  static = {
    modification_icons = {
      added = "",
      changed = "",
      removed = "",
      ignored = "",
    },
  },
  condition = conds().is_git_repo,
  {
    hl = function(self)
      return { fg = "added" }
    end,
    {
      provider = function(self)
        return ("%s %s"):format(
          self.modification_icons.added,
          self.status_dict.added
        )
      end,
    },
    git.spacer,
  },
  {
    hl = function(self)
      return { fg = "changed" }
    end,
    {
      provider = function(self)
        return ("%s %s"):format(
          self.modification_icons.changed,
          self.status_dict.changed
        )
      end,
    },
    git.spacer,
  },
  {
    hl = function(self)
      return { fg = "deleted" }
    end,
    {
      provider = function(self)
        return ("%s %s"):format(
          self.modification_icons.removed,
          self.status_dict.removed
        )
      end,
    },
    vim.tbl_extend("force", git.spacer, {
      condition = function(self)
        return self.status_dict.ignored ~= nil
      end,
    }),
  },
  {
    hl = function(self)
      return { fg = "ignored" }
    end,
    provider = function(self)
      return ("%s %s"):format(
        self.modification_icons.ignored,
        self.status_dict.ignored
      )
    end,
    condition = function(self)
      return self.status_dict.ignored ~= nil
    end,
  },
}

---@class environment.status.component.git
M.git = {
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict or vim.g.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0
      or self.status_dict.removed ~= 0
      or self.status_dict.changed ~= 0
      or self.status_dict.ignored ~= 0
  end,
  condition = conds().is_git_repo,
  hl = function(self)
    return {
      fg = "status_bg",
      bg = "status_bg",
    }
  end,
  on_click = {
    callback = function()
      vim.schedule_wrap(function()
        vim.cmd([[Neogit]])
      end)
    end,
    name = "heirline_git",
  },
  utils().surround(
    { M.SEPARATORS.bottom.right, M.SEPARATORS.bottom.left },
    function(self)
      return self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM)
    end,
    utils().surround({ M.SEPARATORS.spacer, M.SEPARATORS.spacer }, nil, {
      git.branch,
      M.spacer,
      {
        provider = "",
        hl = function(self)
          return { fg = "status_fg" }
        end,
      },
      spacer(2),
      git.modifications,
    })
  ),
}

M.workdir = {
  hl = function(self)
    return {
      fg = "status_bg",
      bg = self:colormode(),
      bold = true,
    }
  end,
  utils().surround({ M.SEPARATORS.top.xright, M.SEPARATORS.spacer }, nil, {
    M.spacer,
    {
      provider = function(self)
        local icon = (vim.fn.haslocaldir(0) == 1 and "l:" or "g:")
          .. " "
          .. " "
        local cwd = vim.fn.getcwd(self.winnr)
        cwd = vim.fn.fnamemodify(cwd, ":~")
        if not conds().width_percent_below(#cwd, 0.25) then
          cwd = vim.fn.pathshorten(cwd)
        end
        local trail = cwd:sub(-1) == "/" and "" or "/"
        return icon .. cwd .. trail
      end,
    },
  }),
}

M.configtime = {
  static = {
    icon = "",
  },
  init = function(self)
    self.timewasted = require("configpulse").get_time()
  end,
  provider = function(self)
    local timestr = ("󰙹 %s days, 󱦣 %s:%s"):format(self.timewasted)
    return self:iconset(timestr)
  end,
  hl = function(self)
    local modecol = self:colormode()
    return { fg = modecol, italic = true }
  end,
}

M.typing_speed = {
  static = {
    icon = "󰗗",
  },
  -- update = {
  --   "InsertEnter",
  --   "InsertChange",
  --   "InsertLeavePre",
  --   pattern = "*",
  --   callback = function()
  --     vim.schedule(function()
  --       vim.cmd.redrawstatus()
  --     end)
  --   end,
  -- },
  condition = function(self)
    self.wpm = require("wpm").wpm()
    return self.wpm and self.wpm > 0
  end,
  hl = hltr({
    fg = "@number.float",
    bg = "LspInlayHint",
  }),
  utils().surround(
    { M.SEPARATORS.section.left, M.SEPARATORS.section.left },
    nil,
    {
      M.spacer,
      {
        provider = function(self)
          return self:iconset(self.wpm)
        end,
      },
      M.spacer,
    }
  ),
}

M.keystrokes = {
  static = {
    icon = "",
  },
  condition = function(self)
    local has, noice = pcall(require, "noice")
    return has and noice.api.status.command.has() or false
  end,
  hl = function(self)
    return {
      fg = heirhl("@constructor.lua").fg,
      bg = "status_bg",
    }
  end,
  utils().surround(
    { M.SEPARATORS.section.left, M.SEPARATORS.section.left },
    nil,
    {
      M.spacer,
      {
        init = function(self)
          local has, noice = pcall(require, "noice")
          self.cmd = has and noice.api.status.command.get() or nil
        end,
        provider = function(self)
          return self.cmd and self:iconset(self.cmd) or nil
        end,
      },
      M.spacer,
    }
  ),
}

local lang = {}

lang.metals_status = {
  static = {
    icon = "",
  },
  provider = function(self)
    return self:iconset(vim.g.metals_status)
  end,
  condition = function(self)
    return conds().buffer_matches({
      filetype = { "scala", "scl" },
    })
  end,
}

local lsp = {}

lsp.attached = {
  init = function(self)
    self.attached = vim.lsp.get_clients({ bufnr = self.bufnr })
  end,

  -- You can keep it simple,
  -- provider = " [LSP]",

  -- Or complicate things a bit and get the servers names
  provider = function(self)
    local names = {}
    for i, server in pairs(self.attached) do
      names[i] = server.name
    end
    return self:iconset(table.concat(names, ":"))
  end,
  hl = function(self)
    return {
      fg = "lsp_fg",
      bold = true,
    }
  end,
}

lsp.status = {
  init = function(self)
    self.status = require("lsp-status").status()
  end,
  condition = function(self)
    return self.status ~= nil
  end,
  spacer(2),
  {
    provider = function(self)
      return self.status
    end,
  },
  spacer(2),
}

lsp.languages = {
  vim.tbl_values(lang),
}

M.lsp = {
  -- update = { "LspAttach", "LspDetach" },
  condition = conds().lsp_attached,
  static = {
    icon = "",
  },
  hl = function(self)
    return { fg = "status_fg", bg = "status_bg" }
  end,
  on_click = {
    callback = function()
      vim.schedule_wrap(function()
        vim.cmd([[LspInfo]])
      end)
    end,
    name = "heirline_lsp",
  },
  utils().surround(
    { M.SEPARATORS.midsection.left, M.SEPARATORS.midsection.right },
    function(self)
      return heirhl("LspInlayHint").bg
    end,
    {
      lsp.attached,
      lsp.status,
      lsp.languages,
    }
  ),
  spacer(2),
}

M.localtime = {
  static = {
    icon = "󱇼",
  },
  hl = function(self)
    return {
      bg = self:colormode(),
      fg = "status_bg",
      italic = true,
    }
  end,
  utils().surround(
    {
      M.SEPARATORS.bottom.xleft .. M.SEPARATORS.spacer,
      M.SEPARATORS.spacer,
    },
    nil,
    {
      provider = function(self)
        return self:iconset(os.date("%H:%M @ %Y-%m-%d "))
      end,
    }
  ),
}

M.weather = {
  static = {
    icon = "",
  },
  hl = function(self)
    return {
      bg = self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM),
      fg = "diagnostic_info",
      italic = true,
    }
  end,
  on_click = {
    callback = function()
      vim.schedule_wrap(require("wttr").get_forecast())
    end,
    name = "heirline_weather",
  },
  M.transition_separator({
    corner = "bottom-right",
    fg = {
      left = function(self)
        return "status_bg"
      end,
      right = function(self)
        return self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM)
      end,
    },
    bg = {
      left = function(self)
        return self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM)
      end,
      right = function(self)
        return "status_bg"
      end,
    },
  }),
  M.spacer,
  {
    init = function(self)
      self.text = string.gsub(require("wttr").text, ":", " ")
    end,
    provider = function(self)
      return self.text
    end,
  },
  M.transition_separator({
    corner = "bottom-right",
    fg = {
      left = function(self)
        return self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM)
      end,
      right = function(self)
        return "status_bg"
      end,
    },
    bg = {
      left = function(self)
        return self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM)
      end,
      right = function(self)
        return self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM)
      end,
    },
  }),
}

local bufs = {}

bufs.bufnr = {
  provider = function(self)
    return ("%s 󰣧 %s "):format(self.bufnr, M.SEPARATORS.section.left)
  end,
  hl = function(self)
    if self.is_active then
      return { fg = "status_bg", bold = true }
    else
      return { fg = heirhl("@punctuation").fg }
    end
  end,
}

bufs.fileflags = {
  hl = function(self)
    return { fg = heirhl("@exception").fg }
  end,
  {
    condition = function(self)
      return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
    end,
    provider = "󰲶",
  },
  {
    condition = function(self)
      return vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
        or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
    end,
    provider = function(self)
      if
        vim.api.nvim_get_option_value("buftype", { buf = self.bufnr })
        == "terminal"
      then
        return "  "
      else
        return " 󰍁"
      end
    end,
  },
}

bufs.close = {
  condition = function(self)
    return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
  end,
  { provider = "  " },
  {
    provider = "󰅘 ",
    hl = function(self)
      if not self.is_active then
        return { fg = heirhl("Comment").fg }
      else
        return { fg = "status_bg" }
      end
    end,
    on_click = {
      callback = function(_, minwid)
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
          vim.cmd.redrawtabline()
        end)
      end,
      minwid = function(self)
        return self.bufnr
      end,
      name = "heirline_tabline_close_buffer_callback",
    },
  },
}

bufs.name = {
  hl = function(self)
    if self.is_active then
      return { fg = "status_bg" }
    else
      return { fg = "status_fg" }
    end
  end,
  provider = function(self)
    local filename = vim.api.nvim_buf_get_name(self.bufnr)
    filename = filename == "" and "--- none ---"
      or vim.fn.fnamemodify(filename, ":t")
    return filename
  end,
}

---@class environment.status.component.bufline.item
bufs.fileblock = {
  on_click = {
    callback = function(_, minwid, _, button)
      if button == "m" then
        vim.schedule_wrap(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
        end)
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = "heirline_tabline_bufferline_callback",
  },
  bufs.bufnr,
  file.icon,
  utils().insert({
    hl = function(self)
      return { bold = self.is_active or self.is_visible, italic = true }
    end,
  }, bufs.name),
  bufs.fileflags,
}

local tabs = {}

tabs.bufline = {
  init = function(self)
    self.active = {
      hl = {
        fg = "status_bg",
        bg = self:colormode(),
      },
      separator = {
        left = M.SEPARATORS.top.left,
        right = M.SEPARATORS.top.right,
      },
    }
    self.inactive = {
      hl = {
        fg = "status_bg",
        bg = self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM),
      },
      separator = {
        left = M.SEPARATORS.top.left,
        right = M.SEPARATORS.top.right,
      },
    }
  end,
  hl = function(self)
    if self.is_active then
      return { fg = self.active.hl.fg, bg = self.active.hl.bg }
    else
      return { fg = self.inactive.hl.fg, bg = self.inactive.hl.bg }
    end
  end,
  utils().surround(
    {
      function(self)
        if self.is_active then
          return self.active.separator.left
        else
          return self.inactive.separator.left
        end
      end,
      function(self)
        if self.is_active then
          return self.active.separator.right
        else
          return self.inactive.separator.right
        end
      end,
    },
    nil,
    utils().surround({ M.SEPARATORS.spacer, M.SEPARATORS.spacer }, nil, {
      bufs.fileblock,
      bufs.close,
    })
  ),
}

tabs.bufline = utils().make_buflist(tabs.bufline, {
  provider = "",
  hl = function()
    return { fg = "status_fg_dim" }
  end,
}, {
  provider = "",
  hl = function()
    return { fg = "status_fg_dim" }
  end,
})

tabs.page = {
  provider = function(self)
    local name = self.tabpage
    local id = string.format([[%s]], name)
    return "󰓩 " .. "%" .. self.tabnr .. "T" .. ": " .. id .. " %T"
  end,
}

tabs.close = {
  provider = "%999X 󰅖 %X",
  hl = function(self)
    return { bg = "tabline_bg", fg = "status_fg" }
  end,
}

tabs.offset = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win
    if vim.bo[bufnr].filetype == "NvimTree" then
      self.title = " owl:tree "
      return true
    elseif vim.bo[bufnr].filetype == "Outline" then
      self.title = " owl:code "
      return true
    else
      self.title = " owl:pane "
      return false
    end
  end,
  provider = function(self)
    local title = self.title
    local width = vim.api.nvim_win_get_width(self.winid)
    local pad = math.ceil((width - #title) / 2)

    return string.rep(" ", pad)
  end,
  hl = function(self)
    if vim.api.nvim_get_current_win == self.winid then
      return { bg = "tablinesel_bg" }
    else
      return { bg = "status_bg" }
    end
  end,
}

tabs.pages = {
  condition = function(self)
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  -- { provider = "%=" },
  utils().make_tablist(tabs.page),
  tabs.close,
}

M.bufline = {
  -- update = {
  --   "BufNew",
  --   "BufEnter",
  --   "BufReadPost",
  --   "BufNew",
  --   "BufDelete",
  --   "BufLeave",
  --   "BufWrite",
  --   "FocusGained",
  --   "FocusLost",
  --   "ModeChanged",
  --   "CursorHold",
  --   "VimEnter",
  --   pattern = "*:*",
  --   callback = function(ev)
  --     vim.schedule_wrap(function()
  --       vim.cmd("redrawtabline")
  --     end)
  --   end,
  -- },
  hl = function(self)
    if self.is_active then
      return {
        fg = "status_bg",
        bg = self:colormode(),
      }
    else
      return {
        fg = "status_bg",
        bg = "status_bg",
      }
    end
  end,
  tabs.offset,
  tabs.bufline,
}

M.tabpages = {
  hl = function(self)
    if self.is_active then
      return {
        fg = "status_bg",
        bg = self:colormode(),
      }
    else
      return "TabLine"
    end
  end,
  tabs.pages,
}

M.snippets = {
  static = {
    icon = "",
  },
  init = function(self)
    self.forward = require("luasnip").expand_or_jumpable() or false
    self.backward = require("luasnip").jumpable(-1) or false
  end,
  condition = function(self)
    return vim.tbl_contains({ "s", "i" }, vim.fn.mode())
  end,
  provider = function(self)
    local forward = self.forward and "󰑨" or ""
    local backward = self.backward and "󰑦" or ""
    local sep = (self.forward and self.backward) and " " or ""
    return self:iconset(("%s%s%s"):format(backward, sep, forward))
  end,
  hl = function(self)
    return { fg = heirhl("CmpItemKindSnippet").fg }
  end,
}

M.breadcrumbs = {
  utils().surround(
    { M.SEPARATORS.spacer, M.SEPARATORS.top.right },
    function(self)
      return heirhl("LspInlayHint").bg
    end,
    {
      provider = function(self)
        return "%{%v:lua.dropbar.get_dropbar_str()%}"
      end,
    }
  ),
}

M.timers = {
  static = {
    icon = "󰅕",
  },
  init = function(self)
    local pulse = require("pulse")
    self.hours, self.minutes = pulse.status("standard")
  end,
  hl = function(self)
    return {
      fg = heirhl("Todo").bg,
      bg = "status_bg",
      italic = true,
    }
  end,
  utils().surround(
    { M.SEPARATORS.section.left, M.SEPARATORS.section.left },
    nil,
    {
      M.spacer,
      {
        provider = function(self)
          if self.hours <= 0 then
            if self.minutes <= 0 then
              return
            end
            return self:iconset(("%s m"):format(self.minutes))
          end
          return self:iconset(("%s h, %s m"):format(self.hours, self.minutes))
        end,
      },
      M.spacer,
    }
  ),
}

M.recording = {
  static = {
    icon = "󰻂",
  },
  init = function(self)
    local has, noice = pcall(require, "noice")
    self.recordmode = has
      and (noice.api.status.mode.get()):gsub("recording ", "r: ")
  end,
  condition = function(self)
    local has, noice = pcall(require, "noice")
    return has and noice.api.status.mode.has() or false
  end,
  hl = function(self)
    return {
      fg = "status_bg",
      bg = "diagnostic_error",
      bold = true,
    }
  end,
  utils().surround({ M.SEPARATORS.top.xright, M.SEPARATORS.top.xleft }, nil, {
    provider = function(self)
      return self.recordmode and self:iconset(self.recordmode) or nil
    end,
  }),
}

M.searchcount = {
  condition = function(self)
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    local search = self.search
    return string.format(
      "󱉶 :| %d/%d |",
      search.current,
      math.min(search.total, search.maxcount)
    )
  end,
  hl = function(self)
    return { fg = heirhl("@tag.delimiter").fg }
  end,
}

local ram_spacer = {
  M.spacer,
  {
    provider = "󱒯",
    hl = function(self)
      return { fg = "status_fg" }
    end,
  },
  M.spacer,
}
M.ram = {
  static = {
    icons = {
      used = "󱈮",
      free = "󱈰",
      constrained = "󱈴",
      available = "󱈲",
      separator = "󱒯",
      rss = "󰚐 /󰳪",
    },
    bytes_per = 1073741824,
  },
  hl = function(self)
    return {
      fg = "status_bg",
      bg = self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM),
    }
  end,
  init = function(self)
    self.total = vim.uv.get_total_memory()
    self.free = vim.uv.get_free_memory()
    self.used = (self.total - self.free)
    self.available = vim.uv.get_available_memory()
    self.rss = vim.uv.resident_set_memory()
    self.text = {
      free = ("%.1f"):format(self.free),
      used = ("%.1f"):format(self.used),
      available = ("%.1f"):format(self.available),
    }
  end,
  utils().surround(
    { M.SEPARATORS.top.xright, M.SEPARATORS.top.xleft },
    nil,
    utils().surround({ M.SEPARATORS.spacer, M.SEPARATORS.spacer }, nil, {
      {
        init = function(self)
          self.aggregate = self.free / self.total * 100
          self.text = ("%.1f"):format(self.aggregate)
        end,
        condition = function(self)
          return self.free ~= self.available
        end,
        {
          provider = function(self)
            return ("%s %s%%"):format(self.icons.free, self.text)
          end,
          hl = function(self)
            return { fg = heirhl("@keyword").fg }
          end,
        },
        ram_spacer,
      },
      {
        init = function(self)
          self.aggregate = self.used / self.total * 100
          self.text = ("%.1f"):format(self.aggregate)
        end,
        condition = function(self)
          return self.aggregate ~= 0
        end,
        {
          provider = function(self)
            return ("%s %s%%"):format(self.icons.used, self.text)
          end,
          hl = function(self)
            return { fg = heirhl("@lsp.type.method").fg }
          end,
        },
        ram_spacer,
      },
      {
        init = function(self)
          self.aggregate = self.available / self.total * 100
          self.text = ("%.1f"):format(self.aggregate)
        end,
        {
          provider = function(self)
            return ("%s %s%%"):format(self.icons.available, self.text)
          end,
          hl = function(self)
            return { fg = heirhl("@character").fg }
          end,
        },
        ram_spacer,
      },
      {
        init = function(self)
          self.aggregate = self.rss / self.total * 100
          self.text = ("%.1f"):format(self.aggregate)
        end,
        {
          provider = function(self)
            return ("%s %s%%"):format(self.icons.rss, self.text)
          end,
          hl = function(self)
            if self.rss / self.available >= 1 then
              return { fg = "diagnostic_error" }
            elseif self.rss / self.available >= 0.5 then
              return { fg = "diagnostic_warn" }
            else
              return { fg = "diagnostic_info" }
            end
          end,
        },
      },
    })
  ),
}

local function __diagnostics(config)
  config = config or {}
  local ic = require("util.table").klower(require("env.ui").icons.diagnostic)
  local comp = {
    condition = conds().has_diagnostics,
    static = {
      icon = ic,
    },
    init = function(self)
      self.errors = #vim.diagnostic.get(
        config.scope == "buffer" and self.bufnr or nil,
        { severity = vim.diagnostic.severity.ERROR }
      )
      self.warnings = #vim.diagnostic.get(
        config.scope == "buffer" and self.bufnr or nil,
        { severity = vim.diagnostic.severity.WARN }
      )
      self.hints = #vim.diagnostic.get(
        config.scope == "buffer" and self.bufnr or nil,
        { severity = vim.diagnostic.severity.HINT }
      )
      self.info = #vim.diagnostic.get(
        config.scope == "buffer" and self.bufnr or nil,
        { severity = vim.diagnostic.severity.INFO }
      )
    end,
    -- update = { "DiagnosticChanged", "BufEnter" },
    hl = function(self)
      return {
        fg = "status_fg",
        bg = "status_bg",
      }
    end,
    on_click = {
      callback = function()
        vim.schedule_wrap(function()
          require("trouble").toggle({ mode = "document_diagnostics" })
        end)
      end,
      name = "heirline_diagnostics",
    },
    utils().surround({
      M.SEPARATORS.top.xleft,
      M.SEPARATORS.top.xright,
    }, function(self)
      return self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM)
    end, {
      M.spacer,
      {
        condition = function(self)
          return self.errors > 0
        end,
        hl = function(self)
          return { fg = "diagnostic_error" }
        end,
        {
          provider = function(self)
            return self.icon.error
          end,
        },
        {
          provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors .. " "
          end,
        },
      },
      {
        condition = function(self)
          return self.warnings > 0
        end,
        hl = function(self)
          return { fg = "diagnostic_warn" }
        end,
        {
          provider = function(self)
            return self.icon.warn
          end,
        },
        {
          provider = function(self)
            return self.warnings .. " "
          end,
        },
      },
      {
        condition = function(self)
          return self.info > 0
        end,
        hl = function(self)
          return { fg = "diagnostic_info" }
        end,
        {
          provider = function(self)
            return self.icon.info
          end,
        },
        {
          provider = function(self)
            return self.info .. " "
          end,
        },
      },
      {
        condition = function(self)
          return self.hints > 0
        end,
        hl = function(self)
          return { fg = "diagnostic_hint" }
        end,

        {
          provider = function(self)
            return self.icon.hint
          end,
        },
        {
          provider = function(self)
            return self.hints
          end,
        },
      },
      M.spacer,
    }),
  }
  return comp
end

M.diag = {
  { provider = "󱪘" },
  M.spacer,
}

M.diag.workspace = __diagnostics({ scope = "workspace" })
M.diag.buffer = __diagnostics({ scope = "buffer" })

M.selectioncount = {
  static = {
    icon = "󱊄",
  },
  init = function(self)
    self.mode = self:curmode({ short = false, active = false })
    local line_start, col_start = vim.fn.line("v"), vim.fn.col("v")
    local line_end, col_end = vim.fn.line("."), vim.fn.col(".")
    self.line_diff = math.abs(line_start - line_end) + 1
    self.col_diff = math.abs(col_start - col_end) + 1
    self.selections = {
      line_start = line_start,
      col_start = col_start,
      line_end = line_end,
      col_end = col_end,
    }
  end,
  provider = function(self)
    local res
    if self.mode:match("") then
      res = string.format("%d×%d", self.line_diff, self.col_diff)
    elseif
      self.mode:match("V")
      or self.selections.line_start ~= self.selections.line_end
    then
      res = self.line_diff
    elseif self.mode:match("v") then
      res = self.col_diff
    else
      res = ""
    end
    return self:iconset(res)
  end,
  hl = function(self)
    return { fg = heirhl("HlSearchLens").fg }
  end,
}

M.wrap_mode = {
  static = {
    icon = "󰖶",
  },
  condition = function(self)
    local has_wrap, wrap = pcall(require, "wrapping")
    self.wrapmode = has_wrap and wrap.get_current_mode() or nil
    return self.wrapmode ~= nil and self.wrapmode ~= ""
  end,
  provider = function(self)
    return self:iconset(self.wrapmode)
  end,
}

M.codeium = {
  static = {
    icon = "󰢛",
  },
  init = function(self)
    self.codeium_status = vim.fn["codeium#GetStatusString"]()
  end,
  condition = function(self)
    local cond = function(it)
      local has, mod = pcall(require, it)
      if not has then
        return false
      end
      return true
    end
    return cond("codeium.nvim")
  end,
  provider = function(self)
    return self:iconset(self.codeium_status)
  end,
}

M.codecompanion = {
  static = {
    processing = false,
  },
  update = {
    "User",
    pattern = "CodeCompanionRequest",
    callback = function(self, args)
      self.processing = (args.data.status == "started")
      vim.schedule_wrap(function()
        vim.cmd.redrawstatus()
      end)
    end,
  },
  {
    condition = function(self)
      return self.processing
    end,
    provider = " ",
    hl = function(self)
      return { fg = heirhl("@text.reference").fg }
    end,
  },
}

M.grapple = {
  static = {
    icon = "",
  },
  condition = function(self)
    local has_grapple, grapple = pcall(require, "grapple")
    self.exists = has_grapple and grapple.exists()
    return self.exists or false
  end,
  init = function(self)
    self.key = self.exists and require("grapple").statusline() or nil
  end,
  provider = function(self)
    return self.key and self:iconset(self.key)
  end,
}

M.music = {
  static = {
    icon = "󱍹",
  },
  init = function(self)
    self.progress = vim.g.mpv_percent
  end,
  condition = function(self)
    self.title = vim.g.mpv_title
    return self.title ~= nil and self.title ~= ""
  end,
  hl = function(self)
    return { bg = "status_bg" }
  end,
  on_click = {
    callback = function()
      vim.schedule_wrap(function()
        require("mpv").toggle_player()
      end)
    end,
    name = "mpv",
  },
  utils().surround(
    { M.SEPARATORS.top.xleft, M.SEPARATORS.top.xright },
    function(self)
      return self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM)
    end,
    {
      provider = function(self)
        return self:iconset(
          self.title .. ": " .. vim.g.mpv_visualizer .. " " .. self.progress
        )
      end,
    }
  ),
}

M.trouble = {
  static = {
    icon = "󱔃 ",
  },
  condition = function(self)
    local trouble = require("trouble")
    self.symbols = trouble.statusline({
      mode = "lsp_document_symbols",
      groups = {},
      title = false,
      filter = { range = true },
      format = "{kind_icon}{symbol.name:Normal}",
      hl_group = "LspInlayHint",
    })
    return self.symbols.get()
  end,
  hl = function(self)
    return {
      bg = "status_bg",
      fg = "status_fg",
    }
  end,
  utils().surround({
    M.SEPARATORS.top.xleft,
    M.SEPARATORS.top.xright,
  }, function(self)
    return self:lightmode(MODE_DEPENDENT_HSL_BASE_TRANSFORM)
  end, {
    {
      provider = function(self)
        return self:iconset(self.symbols.get())
      end,
    },
  }),
}

M.configpulse = {
  static = {
    icon = "󰺈",
  },
  hl = function(self)
    return {
      bg = "status_bg",
      fg = heirhl("@diff.minus").fg,
    }
  end,
  init = function(self)
    self.times = require("configpulse").get_time()
  end,
  utils().surround(
    {
      M.SEPARATORS.section.left,
      M.SEPARATORS.section.left,
    },
    nil,
    {
      M.spacer,
      {
        provider = function(self)
          local timestr = ("%s d %s:%s"):format(
            self.times.days,
            self.times.hours,
            self.times.minutes
          )
          return self:iconset(timestr)
        end,
      },
      M.spacer,
    }
  ),
}

return M
