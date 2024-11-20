local colenv = require('env.color')

local conv = require("util.convert")
local lz = require("util.lazy")
local bg_style = os.getenv("NIGHTOWL_BACKGROUND")
local scheme_sel = os.getenv("NIGHTOWL_COLORSCHEME")

if conv.bool_from_env("NIGHTOWL_DEBUG") then
  local cmdr = require("util.autocmd").autocmdr("NightowlColorschemeInfo")
  cmdr({ "User" }, {
    pattern = "MiniStarterOpened",
    callback = function(ev)
      vim.schedule_wrap(function()
        lz.info("Selected Background: " .. bg_style)
      end)
      vim.schedule_wrap(function()
        lz.info("Selected Colorscheme: " .. scheme_sel)
      end)
    end,
  })
end

local defhl = require("util.paint").paint

local cs_autocmdr =
  require("util.autocmd").autocmdr("RequiredHighlight", true)

local brush = require("util.paint")
cs_autocmdr({ "VimEnter", "ColorScheme" }, {
  callback = function(ev)
    local owhl = vim.api.nvim_create_namespace("NightowlNvim")

    brush.dpaint(colenv.highlights)
  end,
})

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      globalStatus = true,
      dimInactive = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = false, bold = true },
      statementStyle = { bold = true },
      typeStyle = { italic = true },
      background = { dark = "wave", light = "lotus" },
      transparent = false,
    },
  },
  {
    "rebelot/kanagawa.nvim",
    -- overrides somehighlighting colors to get a more modern output for some
    -- views.
    opts = function(_, opts)
      opts.overrides = opts.overrides
        or function(colors)
          local theme = colors.theme
          local pcol = colors.palette
          return {
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = {
              fg = theme.ui.fg_dim,
              bg = theme.ui.bg_m1,
            },
            TelescopeResultsBorder = {
              fg = theme.ui.bg_m1,
              bg = theme.ui.bg_m1,
            },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = {
              bg = theme.ui.bg_dim,
              fg = theme.ui.bg_dim,
            },
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            InclineNormal = { bg = theme.ui.bg_p2 },
            InclineNormalNC = { bg = theme.ui.bg_dim },
            WinBar = { bg = pcol.sumiInk4 },
            WinBarNC = { bg = pcol.sumiInk4 },

            BiscuitColor = { link = "NightowlContextHints" },
            LspInlayHint = { link = "NightowlInlayHints" },
            TreesitterContextBottom = { underline = true },
            NightowlStartupEntry = {
              bold = true,
              fg = pcol.springViolet2,
            },
            NightowlStartupHeader = {
              bold = true,
              fg = pcol.springViolet1,
            },
            NightowlStartupConvenience = {
              bold = false,
              fg = pcol.waveBlue2,
            },
            Headline = {
              fg = pcol.sumiInk0,
              bg = pcol.sumiInk0,
            },
          }
        end
    end,
  },
  {
    "Verf/deepwhite.nvim",
    priority = 980,
    init = function()
      local dw_accent = "#E5E5E5"
      defhl({ "TreesitterContextBottom" }, { underline = true })
      defhl({ "NightowlContextHints" }, { italic = true, fg = dw_accent })
      defhl({ "WinSeparator" }, { fg = dw_accent })
      defhl({ "Headline" }, { fg = dw_accent, bg = dw_accent })
    end,
    opts = {
      low_blue_light = true,
    },
    lazy = false,
  },
  {
    "ronisbr/nano-theme.nvim",
    priority = 930,
    config = function(_, opts) end,
    opts = {
      background = {
        override = false,
        style = "light",
      },
    },
    lazy = false,
  },
  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        styles = {
          comments = "italic",
          functions = "bold",
          constants = "bold",
          keywords = "bold,italic",
        },
        module_default = true,
      },
    },
    lazy = false,
    priority = 970,
  },
  {
    "EdenEast/nightfox.nvim",
    opts = function(_, opts)
      opts.groups = vim.tbl_deep_extend("force", opts.groups or {}, {
        all = {
          TelescopeTitle = {
            fg = "palette.sel1",
            style = "italic",
          },
          TelescopePromptNormal = { bg = "palette.bg2" },
          TelescopePromptBorder = { fg = "palette.bg2", bg = "palette.bg1" },
          TelescopeResultsNormal = {
            fg = "palette.fg1",
            bg = "palette.bg0",
          },
          TelescopeResultsBorder = {
            fg = "palette.bg0",
            bg = "palette.bg1",
          },
          TelescopePreviewNormal = { bg = "palette.bg1" },
          TelescopePreviewBorder = {
            bg = "palette.bg1",
            fg = "palette.bg0",
          },
          Pmenu = { fg = "palette.bg2", bg = "palette.bg1" },
          PmenuSel = { bg = "palette.bg4" },
          PmenuSbar = { bg = "palette.bg0" },
          PmenuThumb = { bg = "palette.bg4" },
          InclineNormal = { bg = "palette.bg2" },
          InclineNormalNC = { bg = "palette.bg1" },
          WinBar = { bg = "palette.bg0" },
          WinBarNC = { bg = "palette.bg1" },
          NightowlContextHints = {
            fg = "#9e7e7e",
            bg = "palette.bg2",
            style = "italic",
          },
          NightowlContextHintsBright = {
            fg = "#b096af",
            style = "bold,italic",
          },
          BiscuitColor = {
            fg = "#91a4ba",
            style = "italic",
          },
          LspInlayHint = {
            link = "NightowlContextHints",
          },
          TreesitterContextBottom = {
            style = "underline",
          },
        },
      })
    end,
  },
  {
    "sho-87/kanagawa-paper.nvim",
    lazy = false,
    priority = 999,
    opts = {
      undercurl = true,
      transparent = false,
      gutter = true,
      dimInactive = true,
      terminlColors = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = false, bold = true },
      statementStyle = { bold = true },
      typeStyle = { italic = true },
    },
  },
  {
    'sho-87/kanagawa-paper.nvim',
    opts = function(_, opts)
      opts.overrides = opts.overrides
        or function(colors)
          local theme = colors.theme
          local pcol = colors.palette
          return {
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = {
              fg = theme.ui.fg_dim,
              bg = theme.ui.bg_m1,
            },
            TelescopeResultsBorder = {
              fg = theme.ui.bg_m1,
              bg = theme.ui.bg_m1,
            },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = {
              bg = theme.ui.bg_dim,
              fg = theme.ui.bg_dim,
            },
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            InclineNormal = { bg = theme.ui.bg_p2 },
            InclineNormalNC = { bg = theme.ui.bg_dim },
            WinBar = { bg = pcol.sumiInk4 },
            WinBarNC = { bg = pcol.sumiInk4 },

            BiscuitColor = { link = "NightowlContextHints" },
            LspInlayHint = { link = "NightowlInlayHints" },
            TreesitterContextBottom = { underline = true },
            NightowlStartupEntry = {
              bold = true,
              fg = pcol.springViolet2,
            },
            NightowlStartupHeader = {
              bold = true,
              fg = pcol.springViolet1,
            },
            NightowlStartupConvenience = {
              bold = false,
              fg = pcol.waveBlue2,
            },
            Headline = {
              fg = pcol.sumiInk0,
              bg = pcol.sumiInk0,
            },
          }
        end
    end,
  },
  {
    'HoNamDuong/hybrid.nvim',
    opts = {
      terminal_colors = true,
      udnercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        folds = false,
      },
      strikethrough = true,
      inverse = true,
      transparent = false,
    },
    lazy = false,
    priority = 600
  }
}
