-- vim: set ft=lua sts=2 ts=2 sw=2 et:
local uienv = require("env.ui")
local key_macro = require("keys.macro")
local key_wrap = require("keys.editor").wrapping
local key_guid = require("keys.editor").guid
local key_tool = require("keys.tool")

return {
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      start_of_line = false,
      pad_comment_parts = true,
      ignore_blank_line = false,
    },
    version = false,
  },
  {
    "echasnovski/mini.align",
    event = "VeryLazy",
    version = false,
    opts = {
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
    },
  },
  {
    "chrisgrieser/nvim-recorder",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-notify",
    },
    opts = {
      slots = { "a", "b" },
      clear = true,
      dapSharedKeymaps = true,
      mapping = {
        startStopRecording = key_macro.record,
        playMacro = key_macro.play,
        switchSlot = key_macro.switch,
        editMacro = key_macro.edit,
        yankMacro = key_macro.yank,
        add_breakpoint = "<C-q><C-b>",
      },
    },
  },
  {
    "monaqa/dial.nvim",
    config = function(_, opts)
      -- do anything to register new dial targets here. this is somewhat
      -- confusing setup.
    end,
    keys = {
      {
        "<C-y>",
        function()
          require("dial.map").manipulate("increment", "normal")
        end,
        mode = "n",
        desc = "dial=> increment",
      },
      {
        "<C-S-y>",
        function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        mode = "n",
        desc = "dial=> decrement",
      },
      {
        "g<C-y>",
        function()
          require("dial.map").manipulate("increment", "gnormal")
        end,
        mode = "n",
        desc = "dial=> gincrement",
      },
      {
        "g<C-S-y>",
        function()
          require("dial.map").manipulate("decrement", "gnormal")
        end,
        mode = "n",
        desc = "dial=> gdecrement",
      },
      {
        "<C-y>",
        function()
          require("dial.map").manipulate("increment", "normal")
        end,
        mode = "v",
        desc = "dial=> increment",
      },
      {
        "<C-S-y>",
        function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        mode = "v",
        desc = "dial=> decrement",
      },
      {
        "g<C-y>",
        function()
          require("dial.map").manipulate("increment", "gnormal")
        end,
        mode = "v",
        desc = "dial=> gincrement",
      },
      {
        "g<C-S-y>",
        function()
          require("dial.map").manipulate("decrement", "gnormal")
        end,
        mode = "v",
        desc = "dial=> gdecrement",
      },
    },
  },
  {
    "andrewferrier/wrapping.nvim",
    opts = function(_, opts)
      opts.create_commands = true
      opts.create_keymaps = false
      opts.notify_on_switch = true
      opts.auto_set_mode_filetype_allow_list = vim.list_extend(
        opts.auto_set_mode_filetype_allowlist or {},
        { "spaceport", "notify", "noice", "markdown" }
      )
      opts.softener = {
        spaceport = false,
        notify = false,
        noice = false,
        markdown = true,
      }
    end,
    keys = {
      {
        key_wrap.mode.hard,
        function()
          require("wrapping").hard_wrap_mode()
        end,
        mode = "n",
        desc = "wrap:| mode |=> hard",
      },
      {
        key_wrap.mode.soft,
        function()
          require("wrapping").soft_wrap_mode()
        end,
        mode = "n",
        desc = "wrap:| mode |=> soft",
      },
      {
        key_wrap.mode.toggle,
        function()
          require("wrapping").toggle_wrap_mode()
        end,
        mode = "n",
        desc = "wrap:| mode |=> toggle",
      },
      {
        key_wrap.log,
        "<CMD>WrappingOpenLog<CR>",
        mode = "n",
        desc = "wrap:| log |=> open",
      },
    },
  },
  {
    "tamton-aquib/mpv.nvim",
    opts = {
      width = 42,
      height = 4,
      border = uienv.borders.alt,
      setup_widgets = true,
      timer = {
        after = 1000,
        throttle = 100,
      },
    },
    cmd = "MpvToggle",
    keys = {
      {
        key_tool.mpv.toggle,
        function()
          require("mpv").toggle_player()
        end,
        mode = "n",
        desc = "mpv:| player |=> toggle",
      },
    },
  },
  {
    "ds1sqe/guid.nvim",
    event = "BufReadPost",
    opts = {
      upperCaseShortCut = key_guid.uppercase, -- shortcut to generate upper case one
      -- like {C1A4D747-7891-9A84-2B0FDDBD5F06BA3C}
      lowerCaseShortCut = key_guid.lowercase, -- shortcut to generate lower case one
      -- like {2b4b7dda-f812-6ff8-9f22384643078d52}
    },
  },
  {
    "niuiic/track.nvim",
    dependencies = {
      "niuiic/core.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      sign = {
        text = "󰍒",
        text_color = "#00ff00",
        priority = 10,
      },
      search = {
        ---@param mark track.Mark
        entry_label = function(mark)
          return string.format(
            "[%s] %s | %s:%s",
            mark.id,
            mark.desc,
            mark.file,
            mark.lnum
          )
        end,
        ---@param marks track.Mark[]
        ---@return track.Mark[]
        sort_entry = function(marks)
          return require("core").lua.list.sort(marks, function(prev, cur)
            return prev.id < cur.id
          end)
        end,
      },
    },
    keys = {
      {
        "mm",
        function()
          require("track").toggle()
        end,
        desc = "toggle mark",
      },
      {
        "mc",
        function()
          require("track").remove()
        end,
        desc = "remove all marks",
      },
      {
        "mj",
        function()
          require("track").jump_to_next()
        end,
        desc = "jump to next mark",
      },
      {
        "mk",
        function()
          require("track").jump_to_prev()
        end,
        desc = "jump to prev mark",
      },
      {
        "me",
        function()
          require("track").edit()
        end,
        desc = "edit mark",
      },
      {
        "<space>mk",
        function()
          require("track").search()
        end,
        desc = "search marks",
      },
    },
  },
}
