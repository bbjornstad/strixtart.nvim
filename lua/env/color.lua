local M = {}

local function hl(name, attr)
  local utils = require("heirline.utils")
  local full = utils.get_highlight(name)

  if attr then
    full = full[attr]
  end

  full = string.format("#%06x", full or 0)

  return full
end

function M.default_statusline_palette()
  local res = {
    diagnostic_error = hl("DiagnosticError", "fg"),
    diagnostic_info = hl("DiagnosticInfo", "fg"),
    diagnostic_warn = hl("DiagnosticWarn", "fg"),
    diagnostic_hint = hl("DiagnosticHint", "fg"),
    diagnostic_ok = hl("DiagnosticOk", "fg"),
    hint = hl("NightowlContextHints", "fg"),
    bright_hint = hl("NightowlContextHintsBright", "fg"),
    inlay_hint = hl("NightowlInlayHints", "fg"),
    status_bg = hl("LspInlayHint", "bg"),
    status_fg = hl("@operator", "fg"),
    status_fg_dim = hl("Comment", "fg"),
    tabline_bg = hl("TabLine", "bg"),
    tablinesel_bg = hl("TabLineSel", "bg"),
    tabline_fg = hl("@operator", "fg"),
    added = hl("@diff.plus", "fg"),
    changed = hl("@diff.delta", "fg"),
    deleted = hl("@diff.minus", "fg"),
    ignored = hl("DevIconGitIgnore", "fg"),
    lsp_fg = hl("@lsp.type.function", "fg"),
    lsp_bg = hl("LspInlayHint", "bg"),
  }

  return res
end

local brush = require("util.paint")

M.highlights = {
  FloatBorder = { link = "NonText" },
  manBold = { bold = true, underline = true },

  NightowlContextHints = {
    bg = brush.find("Normal").bg,
    fg = brush.find("CursorLine").fg,
    italic = true,
  },
  NightowlContextHintsBright = {
    bg = brush.find("WinBarNC").bg,
    fg = brush.find("CusorLine").fg,
    italic = true,
  },
  NightowlInlayHints = {
    link = "DiagnosticSignInfo",
  },
  NightowlMelonSigns = { link = "@label" },
  NightowlStartupHeader = { link = "@function" },
  NightowlStartupEntry = { link = "NvimIdentifier" },
  NightowlStartupConvenience = { link = "@conditional" },

  BiscuitColor = { link = "NightowlContextHints" },
  LspInlayHint = { link = "NightowlInlayHints" },
  Headline = { link = "NormalFloat" },

  EyelinerPrimary = { bold = true, underline = true },
  EyelinerSecondary = { underline = true },

  DropBarCurrentContext = { bg = "NONE" },
  DropBarMenuCurrentContext = { bg = "NONE" },
  DropBarIconCurrentContext = { bg = "NONE" },
  DropBarPreview = { bg = "NONE" },
}

return M
