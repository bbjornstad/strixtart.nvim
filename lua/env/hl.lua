local brush = require("util.paint")

local M = {}

local function accessor(hlmap)
  hlmap = type(hlmap) ~= table and { syntax = hlmap, palette = hlmap } or hlmap
  vim.validate({
    syntax = { hlmap.syntax, { "function", "table" }, true },
    palette = { hlmap.palette, { "function", "table" }, true },
  })

  local syntax_fn, palette_fn
  if type(hlmap.syntax) == "table" then
    syntax_fn = require("util.fn").taccessor(hlmap.syntax, true)
  end
  if type(hlmap.palette) == "table" then
    palette_fn = require("util.fn").taccessor(hlmap.palette, false)
  end

  return syntax_fn, palette_fn
end

function M.default_highlights(opts)
  local theme, palette = accessor(opts)
  local default_hls = {
    TelescopeTitle = { fg = theme("ui.special"), bold = true },
    TelescopePromptNormal = { bg = theme("ui.bg_p1") },
    TelescopePromptBorder = { fg = theme("ui.bg_p1"), bg = theme("ui.bg_p1") },
    TelescopeResultsNormal = {
      fg = theme("ui.fg_di"),
      bg = theme("ui.bg_m"),
    },
    TelescopeResultsBorder = {
      fg = theme("ui.bg_m"),
      bg = theme("ui.bg_m"),
    },
    TelescopePreviewNormal = { bg = theme("ui.bg_dim") },
    TelescopePreviewBorder = {
      bg = theme("ui.bg_di"),
      fg = theme("ui.bg_di"),
    },
    Pmenu = { fg = theme("ui.shade0"), bg = theme("theme.ui.bg_p1") },
    PmenuSel = { fg = "NONE", bg = theme("ui.bg_p2") },
    PmenuSbar = { bg = theme("ui.bg_m1") },
    PmenuThumb = { bg = theme("ui.bg_p2") },
    InclineNormal = { bg = theme("ui.bg_p2") },
    InclineNormalNC = { bg = theme("ui.bg_dim") },
    WinBar = { bg = palette("sumiInk4") },
    WinBarNC = { bg = palette("sumiInk4") },
    DropBarCurrentContext = { bg = "NONE" },
    DropBarMenuCurrentContext = { bg = "NONE" },
    DropBarIconCurrentContext = { bg = "NONE" },
    DropBarPreview = { bg = "NONE" },
    BiscuitColor = { link = "NightowlContextHints" },
    LspInlayHint = { link = "NightowlInlayHints" },
    TreesitterContextBottom = { underline = true },
    NightowlContextHints = {
      bg = brush.find("Normal").bg,
      fg = brush.find("@function.call").fg,
      italic = true,
    },
    NightowlContextHintsBright = {
      bg = brush.find("Normal").bg,
      fg = brush.find("@tag").fg,
      italic = true,
    },
    NightowlStartupEntry = {
      bold = true,
      fg = palette("springViolet2"),
    },
    NightowlStartupHeader = {
      bold = true,
      fg = palette("springViolet1"),
    },
    NightowlStartupConvenience = {
      bold = false,
      fg = palette("waveBlue2"),
    },
    NightowlInlayHints = {
      link = "DiagnosticSignInfo",
    },
    Headline = {
      fg = palette("sumiInk0"),
      bg = palette("sumiInk0"),
    },
  }
end

function M.resolve() end

return M
