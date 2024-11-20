local ftenv = require("env.filesystem")
local uienv = require("env.ui")

local default_class_separator_style = {
  fgColor = "#7AA89F",
  char = "⬩",
  width = tonumber(vim.o.colorcolumn) or 80,
  name = "ClassSeparator",
}
local default_func_separator_style = {
  fgColor = "#7E9CD8",
  char = "⌁",
  width = tonumber(vim.o.colorcolumn) or 80,
  name = "FuncSeparator",
}

return {
  {
    "yamatsum/nvim-cursorline",
    event = "VeryLazy",
    opts = {
      cursorline = { enable = true, timeout = 300, number = false },
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
      },
    },
  },
  {
    "nacro90/numb.nvim",
    event = "VeryLazy",
    opts = {
      show_numbers = true,
      show_cursorline = true,
      hide_relativenumbers = true,
      number_only = false,
      centered_peeking = true,
    },
  },
  {
    "gorbit99/codewindow.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      local cw = require("codewindow")
      cw.setup(opts)
      cw.apply_default_keybinds()
    end,
    init = function()
      vim.api.nvim_set_hl(0, "CodewindowBackground", { blend = 80 })
    end,
    opts = {
      auto_enable = true,
      exclude_file_types = vim.list_extend(
        ftenv.ft_ignore_list,
        { "mail", "himalaya-email-listing" }
      ),
      minimap_width = 8,
      screen_bounds = "background",
      window_border = uienv.borders.alt,
    },
  },
  {
    "lukas-reineke/virt-column.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      char = "╵",
      virtcolumn = table.concat(uienv.column_rulers or { "+1" }, ","),
      exclude = {
        filetypes = ftenv.ft_ignore_list,
      },
    },
  },
  {
    "CWood-sdf/melon.nvim",
    opts = {
      ignore = function(_)
        return false
      end,
      signOpts = {
        texthl = "NightowlMelonSigns",
      },
    },
    event = "VeryLazy",
  },
  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    opts = {
      alpha = 0.64,
      blend_color = vim.api.nvim_get_hl(0, { name = "Normal" }).background
        or "#000000",
      hide = {
        underline = true,
        virtual_text = true,
        signs = true,
      },
      regex = {
        "[uU]nused",
        "[nN]ever [rR]ead",
        "[nN]ot [rR]ead",
      },
      priority = 128,
      disable = {},
    },
  },
}
