---@diagnostic disable: param-type-mismatch
local env = require("env.ui")
local signs = env.icons.cursorsigns

return {
  {
    "declancm/cinnamon.nvim",
    enabled = false,
    opts = {
      options = {
        mode = "window",
        count_only = false,
        delay = 5,
        max_delta = {
          line = false,
          column = false,
          time = 1000,
        },
        step_size = {
          -- Number of cursor/window lines moved per step
          vertical = 1,
          -- Number of cursor/window columns moved per step
          horizontal = 2,
        },

        -- Optional post-movement callback. Not called if the movement is interrupted
        callback = function() end,
      },
      keymaps = {
        basic = true,
        extra = true,
      },
    },
    lazy = false,
    keys = {},
  },
  {
    "gen740/SmoothCursor.nvim",
    enabled = true,
    lazy = false,
    config = function(_, opts)
      require("smoothcursor").setup(opts)
      local autocmd = vim.api.nvim_create_autocmd
      autocmd({ "ModeChanged" }, {
        group = vim.api.nvim_create_augroup("SmoothCursor", { clear = true }),
        callback = function()
          local current_mode = vim.fn.mode()
          local mode_map = {
            n = "Normal",
            i = "Insert",
            v = "Visual",
            V = "Visual",
            [""] = "Visual",
            c = "Command",
            t = "Terminal",
          }
          local full_mode = mode_map[current_mode] or false
          full_mode = full_mode and full_mode .. "Mode" or nil

          vim.api.nvim_set_hl(0, "SmoothCursor", { link = full_mode })
          vim.fn.sign_define(
            "smoothcursor",
            { text = "*", texthl = "SmoothCursor" }
          )
        end,
      })
    end,
    opts = {
      type = "matrix",
      autostart = true,
      texthl = "SmoothCursor",
      speed = 24,
      threshold = 3,
      intervals = 8,
      priority = 100,
      flyin_effect = "bottom",
      matrix = {
        head = {
          cursor = signs.head,
          texthl = { "SmoothCursor" },
        },
        body = {
          cursor = signs.body,
          length = 7,
          texthl = { "SmoothCursor" },
        },
        tail = {
          cursor = signs.tail,
          texthl = { "SmoothCursor" },
        },
        unstop = false,
      },
    },
  },
  {
    "echasnovski/mini.animate",
    enabled = false,
    version = false,
    opts = function(_, opts)
      local ani = require("mini.animate")
      opts.scroll = {
        enable = true,
        timing = ani.gen_timing.quadratic({ duration = 80, unit = "total" }),
        subscroll = ani.gen_subscroll.equal({
          max_output_steps = 60,
        }),
      }
    end,
  },
}
