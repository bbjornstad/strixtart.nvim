-- SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---@module "parliament.plugins.status" statusline reconfiguration using
---heirline.nvim and friends.
---@author Bailey Bjornstad | ursa-major
---@license MIT

local cmdr = require("util.autocmd").autocmdr("Heirline", true)
local ftenv = require("env.filesystem")
local uienv = require("env.ui")

local function lnumfunc()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())
  local width = wininfo.width
  local height = wininfo.height
end

return {
  {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    opts = function(_, opts)
      opts = opts or {}
      local versed = require("env.status.verse")
      local colormapper = versed.colormapper()
      opts.statusline = vim.tbl_deep_extend(
        "force",
        versed.statusline or {},
        opts.statusline or {}
      )
      opts.winbar =
        vim.tbl_deep_extend("force", versed.winbar or {}, opts.winbar or {})
      opts.tabline =
        vim.tbl_deep_extend("force", versed.tabline or {}, opts.tabline or {})
      opts.opts = vim.tbl_deep_extend("force", {
        disable_winbar_cb = function(args)
          return require("heirline.conditions").buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = {
              "^git.*",
              "fugitive",
              "Trouble",
              "dashboard",
              "Outline",
              "Codewindow",
              "cybu",
              "Cybu",
              "fzf",
              "Telescope",
              "telescope",
              "undotree",
              "portal",
              "Portal",
            },
          }, args.buf)
        end,
        colors = colormapper,
      }, opts.opts or {})
      cmdr({ "ColorScheme" }, {
        callback = function(ev)
          require("heirline.utils").on_colorscheme(colormapper)
        end,
      })
    end,
    config = function(_, opts)
      require("heirline").setup(opts)
    end,
    init = function()
      vim.api.nvim_set_hl(0, "StatusLine", { link = "LspInlayHint" })
      vim.api.nvim_set_hl(0, "TabLine", { link = "NormalNC" })
      vim.api.nvim_set_hl(0, "TabLineFill", { link = "NormalNC" })
      vim.api.nvim_set_hl(0, "WinBar", { link = "Bold" })
      cmdr({ "FileType" }, {
        pattern = "*",
        callback = function(ev)
          if
            vim.fn.index(
              { "wipe", "delete" },
              vim.api.nvim_get_option_value("bufhidden", { buf = ev.buf })
            ) >= 0
          then
            vim.api.nvim_set_option_value("buflisted", false, { buf = ev.buf })
          end
        end,
      })
    end,
    dependencies = {
      "folke/noice.nvim",
      "cbochs/grapple.nvim",
      "jcdickinson/wpm.nvim",
      -- { "zVNoob/heirline-cmdline", optional = true },
    },
  },
  -- {
  --   "zVNoob/heirline-cmdline",
  --   opts = {
  --     max_item = 6,
  --     placeholder_char = "",
  --     keymap = {
  --       confirm = "<C-y>",
  --       next = "<C-j>",
  --       prev = "<C-k>",
  --       force = "<C-S-y>",
  --     },
  --   },
  -- },
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "tzachar/local-highlight.nvim",
    },
    opts = {
      render = function(props)
        local versed = require("env.status.verse")
        local retit = vim.tbl_filter(function(it)
          return it ~= nil or (type(it) == "table" and #it ~= 0)
        end, versed.incline(props))

        -- vim.notify(vim.inspect(retit))
        return retit
      end,
      hide = {
        cursorline = true,
        focused_win = false,
        only_win = false,
      },
      highlight = {
        groups = {
          InclineNormal = {
            default = true,
            group = "CursorLine",
          },
          InclineNormalNC = {
            default = true,
            group = "StatusLineNC",
          },
        },
      },
      window = {
        padding = 1,
        padding_char = " ",
        placement = { horizontal = "left", vertical = "bottom" },
        margin = { vertical = 0, horizontal = 0 },
        width = "fit",
        options = {
          signcolumn = "yes",
          wrap = false,
        },
        winhighlight = {
          active = {
            EndOfBuffer = "None",
            Normal = "InclineNormal",
            Search = "None",
          },
          inactive = {
            EndOfBuffer = "None",
            Normal = "InclineNormalNC",
            Search = "None",
          },
        },
        zindex = 20,
        overlap = {
          tabline = false,
          winbar = false,
          statusline = false,
          borders = false,
        },
      },
    },
  },
  {
    "lewis6991/satellite.nvim",
    opts = {
      current_only = true,
      winblend = 20,
      zindex = 10,
      excluded_filetypes = ftenv.ft_ignore_list,
      width = 4,
      handlers = {
        search = {
          enable = true,
        },
        diagnostic = {
          enable = true,
          signs = { "-", "=", "≡" },
          min_severity = vim.diagnostic.severity.hint,
        },
        gitsigns = {
          enable = true,
          signs = {
            add = "│",
            change = "┆",
            delete = "⦚",
          },
        },
        marks = {
          enable = true,
          show_builtins = false,
          key = "m",
        },
        quickfix = {
          signs = { "↼", "⥚", "⦧" },
        },
      },
    },
    event = "VeryLazy",
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "VimEnter",
    dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
    opts = {
      menu = {
        win_configs = {
          style = "minimal",
          border = uienv.borders.main,
        },
        quick_navigation = true,
        entry = {
          padding = {
            left = 2,
            right = 2,
          },
        },
        keymaps = {
          ["q"] = function()
            local api = require("dropbar.utils")
            local thismenu = api.menu.get_current()
            if not thismenu then
              return
            end
            thismenu:close()
          end,
          ["<leader>"] = function()
            local menu = require("dropbar.utils").menu.get_current()
            menu:fuzzy_find_open()
          end,
        },
      },
      bar = {
        enable = true,
        attach_events = {
          "OptionSet",
          "BufWinEnter",
          "BufWritePost",
        },
        padding = { left = 2, right = 2 },
      },
      win_configs = {
        border = uienv.borders.main,
        style = "minimal",
      },
      icons = {
        enable = true,
        ui = {
          bar = {
            separator = "  ",
            extends = "󱎽",
          },
          menu = {
            separator = " ",
            indicator = "󰋙 ",
          },
        },
        kinds = {
          symbols = vim.tbl_deep_extend("force", {
            Array = "󰅪 ",
            Boolean = " ",
            BreakStatement = "󰙧 ",
            Call = "󱅥 ",
            CaseStatement = "󱃙 ",
            Class = " ",
            Color = "󰏘 ",
            Constant = "󰏿 ",
            Constructor = " ",
            ContinueStatement = "→ ",
            Copilot = " ",
            Declaration = "󰙠 ",
            Delete = "󰩺 ",
            DoStatement = "󰑖 ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = "󰈔 ",
            Folder = "󰉋 ",
            ForStatement = "󰑖 ",
            Function = "󰡱 ",
            H1Marker = "󰉫 ", -- used by markdown treesitter parser
            H2Marker = "󰉬 ",
            H3Marker = "󰉭 ",
            H4Marker = "󰉮 ",
            H5Marker = "󰉯 ",
            H6Marker = "󰉰 ",
            Identifier = "󰓽 ",
            IfStatement = "󰇉 ",
            Interface = " ",
            Keyword = "󰌋 ",
            List = "󰅪 ",
            Log = "󰦪 ",
            Lsp = " ",
            Macro = "󰷵 ",
            MarkdownH1 = "󰉫 ", -- used by builtin markdown source
            MarkdownH2 = "󰉬 ",
            MarkdownH3 = "󰉭 ",
            MarkdownH4 = "󰉮 ",
            MarkdownH5 = "󰉯 ",
            MarkdownH6 = "󰉰 ",
            Method = "󰆧 ",
            Module = "󰏗 ",
            Namespace = "󰅩 ",
            Null = "󰢤 ",
            Number = "󰎠 ",
            Object = "󰅩 ",
            Operator = "󰆕 ",
            Package = "󰆦 ",
            Pair = "󰅪 ",
            Property = " ",
            Reference = "󰦾 ",
            Regex = " ",
            Repeat = "󰑖 ",
            Scope = "󰅩 ",
            Snippet = "󰩫 ",
            Specifier = "󰦪 ",
            Statement = "󰅩 ",
            String = "󰉾 ",
            Struct = " ",
            SwitchStatement = "󰺟 ",
            Text = " ",
            Type = " ",
            TypeParameter = "󰆩 ",
            Unit = " ",
            Value = "󰎠 ",
            Variable = "󱃼 ",
            WhileStatement = "󰑖 ",
          }, uienv.icons.kinds),
        },
      },
    },
    keys = {
      {
        "g-",
        function()
          require("dropbar.api").pick()
        end,
        mode = "n",
        desc = "win:| |=> breadcrumbs",
      },
    },
  },
  {
    "jcdickinson/wpm.nvim",
    opts = {
      sample_count = 10,
      sample_interval = 2000,
      percentile = 0.8,
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    config = function(_, opts)
      require("statuscol").setup(opts)
    end,
    opts = function(_, opts)
      local builtin = require("statuscol.builtin")
      opts = opts or {}
      opts.relculright = opts.relculright ~= nil and opts.relculright or true
      opts.segments = vim.list_extend({
        {
          text = { builtin.lnumfunc, " ", " ", " ", " " },
          condition = { true, builtin.not_empty, builtin.not_empty, true },
          sign = { colwidth = 5, maxwidth = 1 },
          click = "v:lua.ScLa",
        },
        {
          sign = {
            name = { "Diagnostic*" },
            colwidth = 2,
            maxwidth = 1,
            auto = true,
          },
          click = "v:lua.ScSa",
        },
        {
          sign = {
            name = { ".*" },
            colwidth = 1,
            maxwidth = 1,
            auto = true,
            wrap = true,
          },
          click = "v:lua.ScSa",
        },
        {
          sign = {
            name = { "smoothcursor*" },
            colwidth = 2,
            maxwidth = 2,
            auto = true,
          },
          click = "v:lua.ScSa",
        },
        { text = { "⦙" } },
      }, opts.segments or {})
    end,
    event = "VeryLazy",
  },
}
