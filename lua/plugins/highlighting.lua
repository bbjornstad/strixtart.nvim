local env = require("env.ui")

local brush = require("util.paint")

local kenv = require("keys.ui")

local key_easyread = kenv.easyread
local key_block = kenv.block
local key_hlslens = kenv.hlslens

local function kcolors(spec)
  return require("util.fn").smap(function(idx, hl)
    local col = vim.api.nvim_get_hl(0, { name = hl })
    return col.fg
  end, spec)
end

return {
  {
    "mei28/chromabuffer.nvim",
    event = "VeryLazy",
  },
  {
    "winston0410/range-highlight.nvim",
    event = "BufWinEnter",
    config = function() end,
  },
  {
    "m-demare/hlargs.nvim",
    opts = {
      highlight = {
        link = "@number.float",
      },
      excluded_filetypes = env.ft_ignore_list,
      extras = { named_parameters = true },
    },
    event = "VeryLazy",
  },
  {
    "iguanacucumber/highlight-actions.nvim",
    enabled = true,
    opts = {
      highlight_for_count = true,
      duration = 540,
      after_keymaps = function() end,
      keymaps = {
        Undo = {
          disabled = false,
          fg = "#d1cdc2",
          bg = "#2d4f67",
          hlgroup = "HighlightUndo",
          mode = "n",
          keymap = "u",
          cmd = "undo",
          opts = { desc = "vim:| undo |" },
        },
        Redo = {
          disabled = false,
          mode = "n",
          keymap = "<C-r>",
          cmd = "redo",
          opts = { desc = "vim:| redo |" },
          hlgroup = "HighlightRedo",
        },
        Pasted = {
          disabled = false,
          keymap = "p",
          cmd = "put",
          mode = { "n", "v" },
          cmd_args = function()
            return vim.v.register
          end,
          opts = { desc = "vim:| paste |" },
          fg = "#d1cdc2",
          bg = "#236A72",
          hlgroup = "HighlightPasted",
        },
        Yanked = {
          disabled = false,
          keymap = "y",
          cmd = "yank",
          cmd_args = function()
            return vim.v.register
          end,
          opts = { desc = "vim:| yank |" },
          fg = "#d1cdc2",
          bg = "#180733",
          mode = { "n", "v" },
          hlgroup = "HighlightYanked",
        },
      },
    },
    event = "VeryLazy",
  },
  {
    "asiryk/auto-hlsearch.nvim",
    opts = {
      remap_keys = { "/", "?", "*", "#", "n", "N" },
      create_commands = true,
      pre_hook = function() end,
      post_hook = function() end,
    },
  },
  {
    "tzachar/local-highlight.nvim",
    opts = {
      disable_file_types = { "markdown" },
    },
    event = "VeryLazy",
  },
  {
    "HampusHauffman/bionic.nvim",
    cmd = { "Bionic", "BionicOn", "BionicOff" },
    keys = {
      {
        key_easyread,
        "<CMD>Bionic<CR>",
        mode = { "n" },
        desc = "hl:| bionic |=> toggle flow-state reading",
      },
    },
  },
  {
    "HampusHauffman/block.nvim",
    opts = {
      percent = 1.1,
      depth = 8,
      automatic = true,
    },
    cmd = { "Block", "BlockOn", "BlockOff" },
    keys = {
      {
        key_block,
        "<CMD>Block<CR>",
        mode = "n",
        desc = "hl:| block |=> toggle",
      },
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    opts = {
      auto_enable = true,
      enable_incsearch = true,
      calm_down = true,
      nearest_only = false,
      nearest_float_when = "auto",
      float_shadow_bend = 30,
      virt_priority = 40,
    },
    event = "VeryLazy",
    keys = {
      {
        key_hlslens,
        "<CMD>HlSearchLensToggle<CR>",
        mode = "n",
        desc = "ui:| lens |=> toggle",
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      debounce = 100,
      indent = { char = "┆" },
      whitespace = { highlight = { "Whitespace", "NonText" } },
      scope = {
        show_start = true,
        show_end = true,
        injected_languages = true,
        highlight = { "Function", "Label" },
        exclude = {},
      },
    },
    keys = {},
    event = "VeryLazy",
  },
  {
    "Mr-LLLLL/cool-chunk.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function(_, opts)
      local chunk_ft = require("cool-chunk.utils.filetype")
      opts.chunk.support_filetypes = vim.list_extend(
        chunk_ft.support_filetypes,
        opts.chunk.support_filetypes
      )
      opts.chunk.exclude_filetypes = vim.tbl_extend(
        "force",
        chunk_ft.exclude_filetypes,
        require("util.table").invert(opts.chunk.exclude_filetypes)
      )
      require("cool-chunk").setup(opts)
    end,
    opts = {
      line_num = {
        notify = true,
        hl_group = {
          chunk = "DiagnosticInfo",
          error = "DiasgnosticError",
          context = "LineNr",
        },
        support_filetypes = {},
        exclude_filetypes = {
          "spaceport",
          "alpha",
          "dashboard",
          "outline",
          "starter",
          "lazy",
        },
      },
      chunk = {
        notify = true,
        animate_duration = 200,
        support_filetypes = {},
        exclude_filetypes = {
          "spaceport",
          "alpha",
          "dashboard",
          "outline",
          "starter",
          "lazy",
        },
        chars = {
          horizontal_line = "╌",
          vertical_line = "╎",
          left_top = "┌",
          left_bottom = "└",
          right_arrow = "┤",
          left_arrow = "├",
          bottom_arrow = "┴",
        },
        hl_group = {
          chunk = "DiagnosticInfo",
          error = "DiagnosticError",
        },
        textobjects = "ah",
      },
      context = {
        notify = true,
        chars = {
          "╎",
        },
        hl_group = {
          context = "LineNr",
        },
        support_filetypes = {},
        exclude_filetypes = {
          "spaceport",
          "alpha",
          "dashboard",
          "outline",
          "starter",
          "lazy",
        },
        textobject = "ih",
        jump_support_filetypes = { "lua", "python" },
        jump_start = "[{",
        jump_end = "]}",
      },
    },
  },
  {
    "Antony-AXS/indicator.nvim",
    event = "VeryLazy",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      indicator_event = true, -- turns ON the Indicator feature by default
      window_highlight_event = false,
    },
  },
  -- {
  --   "mvllow/modes.nvim",
  --   tag = "v0.2.0",
  --   opts = {
  --     colors = kcolors({
  --       copy = "Added",
  --       delete = "DiffDelete",
  --       insert = "Debug",
  --       visual = "Visual",
  --     }),
  --     line_opacity = 0.10,
  --   },
  --   event = "VeryLazy",
  -- },
  {
    "mawkler/modicator.nvim",
    dependencies = {
      "rebelot/kanagawa.nvim",
    },
    event = "VeryLazy",
    init = function()
      -- these are required options for this plugin. They are also set in the
      -- main options file, but this is helpful for modularity.
      vim.o.cursorline = true
      vim.o.number = true
      -- vim.o.termguicolors = true
    end,
    opts = {
      show_warnings = true,
      highlights = {
        defaults = {
          bold = true,
        },
      },
      integration = {
        lualine = {
          enabled = true,
          highlight = "bg",
        },
      },
    },
  },
  {
    "zbirenbaum/neodim",
    opts = function()
      return {
        alpha = 0.6,
        blend_color = vim.api.nvim_get_hl(0, { name = "Normal" }).background,
        hide = {
          underline = false,
          virtual_text = false,
          signs = true,
        },
        regex = {
          "[uU]nused",
          "[nN]ever [rR]ead",
          "[nN]ot [rR]ead",
        },
        priority = 128,
        disable = {},
      }
    end,
    event = "LSPAttach",
  },
}
