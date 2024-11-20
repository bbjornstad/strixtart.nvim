---@diagnostic disable: param-type-mismatch
local env = require("env.ui")
local ftenv = require("env.filesystem")

local key_fm = require("keys.fm")
local key_shortcut = require("keys.shortcut")

return {
  {
    "JonasLeonhard/broil",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
        build = "make",
      },
    },
    opts = {
      mv_command = 'mv <FROM> <TO>',
      rm_command = 'rm -r --trash <FROM>',
      mkdir_command = 'mkdir <TO>',
      touch_command = 'mkdir (dirname <TO>); touch <TO>',
      mappings = {
        -- general
        help = '?',
        close = '<C-c>',
        pop_history = '<C-p>',
        open_edits_float = '<C-e>',
        open_config_float = '<C-g>',

        -- search
        select_next_node = '<C-j>',
        select_next_node_normal = 'j',
        select_prev_node = '<C-k>',
        select_prev_node_normal = 'k',
        open_selected_node = '<CR>',
        open_selected_node2 = '<C-l>',
        open_parent_dir = '<C-h>',

        -- edits window
        stage_edit = 's',
        stage_all_edits = '<c-s>',
        stage_all_edits2 = '<c-a>',
        unstage_edit = 'S',
        unstage_all_edits = '<c-S>',
        undo_edit = 'U',
        apply_staged_edits = '<c-y>'
      }
    },
    keys = {
      {
        "<leader>fb",
        function()
          require("broil").open()
        end,
        desc = "Broil open",
      },
      {
        "<leader>fB",
        function()
          require("broil").open(vim.fn.getcwd())
        end,
        desc = "Broil open cwd",
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- can be either "succinct" or "extended".
      vim.g.oil_extended_column_mode = ftenv.oil.init_columns == "extended"
    end,
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = true,
      columns = ftenv.oil.init_columns == "succinct" and ftenv.oil.columns.succinct
        or ftenv.oil.columns.extended,
      delete_to_trash = true,
      experimental_watch_for_changes = true,
      git = {
        add = function(path)
          return true
        end,
        mv = function(path)
          return true
        end,
        rm = function(path)
          return true
        end,
      },
      float = {
        padding = 3,
        border = env.borders.main,
        win_options = {
          winblend = 5,
        },
      },
      preview = {
        max_width = { 100, 0.8 },
        min_width = { 32, 0.25 },
        border = env.borders.main,
        win_options = {
          winblend = 20,
        },
      },
      progress = {
        max_width = 0.45,
        min_width = { 40, 0.2 },
        border = env.borders.main,
        minimized_border = env.borders.main,
        win_options = {
          winblend = 20,
        },
      },
      ssh = {
        border = env.borders.main,
      },
      keymaps = {
        ["g."] = "actions.tcd",
        ["<BS>"] = "actions.toggle_hidden",
        ["."] = "actions.toggle_hidden",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["q"] = "actions.close",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["<C-p>"] = "actions.preview",
        ["gc"] = {
          callback = function()
            local extended_is_target = vim.b.oil_extended_column_mode
            or vim.g.oil_extended_column_mode

            require("oil").set_columns(
              extended_is_target and ftenv.oil.columns.extended
              or ftenv.oil.columns.succinct
            )
            vim.b.oil_extended_column_mode = extended_is_target
          end,
          desc = "fm:| oil |=> toggle succinct columns",
        },
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["e"] = "actions.select",
        ["<C-y>"] = "actions.select",
        ["gt"] = "actions.toggle_trash",
        ["<C-t>"] = "actions.select_tab",
        ["<C-q>"] = "actions.add_to_qflist",
        ["<C-l>"] = "actions.add_to_loclist",
        ["<C-L>"] = "actions.send_to_loclist",
        ["<C-Q>"] = "actions.send_to_qflist",
        ["H"] = "actions.parent",
        ["L"] = "actions.select",
        ["gx"] = "open_external",
        ["<C-b>"] = "preview_scroll_up",
        ["<C-f>"] = "preview_scroll_down",
      },
      view_options = {
        sort = {
          { "type", "asc" },
          { "name", "asc" },
          { "ctime", "desc" },
          { "size", "asc" },
        },
      },
      lsp_file_methods = {
        timeout_ms = 2000,
        autosave_changes = true,
      },
    },
    keys = {
      {
        key_fm.oil.open_float,
        function()
          return require("oil").open_float()
        end,
        mode = { "n" },
        desc = "fm:float| oil |=> open",
      },
      {
        key_fm.oil.split,
        function()
          local count = 32
          if vim.v.count > 0 then
            count = vim.v.count
          end
          vim.cmd(([[vsplit | wincmd r | vertical resize %s]]):format(count))
          require("oil").open()
        end,
        mode = "n",
        desc = "fm:split| oil |=> open",
      },
      {
        key_fm.oil.open,
        function()
          require("oil").open()
        end,
        mode = { "n" },
        desc = "fm:| oil |=> open",
      },
      {
        key_shortcut.fm.explore.explore,
        function()
          require("oil").open_float()
        end,
        mode = { "n" },
        desc = "fm:float| oil |=> open",
      },
      {
        key_shortcut.fm.explore.split,
        function()
          local count = 32
          if vim.v.count > 0 then
            count = vim.v.count
          end
          vim.cmd(([[vsplit | wincmd r | vertical resize %s]]):format(count))
          require("oil").open()
        end,
        mode = { "n" },
        desc = "fm:split| oil |=> open",
      },
    },
  },
  {
    "m-demare/attempt.nvim",
    opts = {
      dir = vim.fs.joinpath(vim.fn.stdpath("data"), "attempt.nvim"),
      autosave = false,
      list_buffers = false, -- This will make them show on other pickers (like :Telescope buffers)
      ext_options = {
        "lua",
        "rs",
        "py",
        "cpp",
        "c",
        "ml",
        "md",
        "norg",
        "org",
        "jl",
        "hs",
        "scala",
        "sc",
        "html",
        "css",
      }, -- Options to choose from
    },
    config = function(_, opts)
      require("attempt").setup(opts)
      require("telescope").load_extension("attempt")
    end,
    keys = {
      {
        key_fm.attempt.new_select,
        function()
          require("attempt").new_select()
        end,
        mode = "n",
        desc = "fm:| scratch |=> new buffer",
      },
      {
        key_fm.attempt.new_input_ext,
        function()
          require("attempt").new_input_ext()
        end,
        mode = "n",
        desc = "fm:| scratch |=> new buffer (custom extension)",
      },
      {
        key_fm.attempt.run,
        function()
          require("attempt").run()
        end,
        mode = "n",
        desc = "fm:| scratch |=> run",
      },
      {
        key_fm.attempt.delete,
        function()
          require("attempt").delete_buf()
        end,
        mode = "n",
        desc = "fm:| scratch |=> delete buffer",
      },
      {
        key_fm.attempt.rename,
        function()
          require("attempt").rename_buf()
        end,
        mode = "n",
        desc = "fm:| scratch |=> rename buffer",
      },
      {
        key_fm.attempt.open_select,
        function()
          require("attempt").open_select()
        end,
        mode = "n",
        desc = "fm:| scratch |=> select buffer",
      },
    },
  },
  {
    "dzfrias/arena.nvim",
    opts = {
      max_items = 12,
      always_context = { "mod.rs", "init.lua" },
      ignore_current = true,
      per_project = true,
      window = {
        width = 32,
        height = 12,
        border = env.borders.main,
      },
      algorithm = {
        recency_factor = 0.5,
        frequency_factor = 1,
      },
    },
    keys = {
      {
        key_fm.arena.toggle,
        function()
          require("arena").toggle()
        end,
        mode = "n",
        desc = "fm:| arena |=> toggle",
      },
      {
        key_fm.arena.open,
        function()
          require("arena").open()
        end,
        mode = "n",
        desc = "fm:| arena |=> open",
      },
      {
        key_fm.arena.close,
        function()
          require("arena").close()
        end,
        mode = "n",
        desc = "fm:| arena |=> close",
      },
    },
  },
  {
    "jackMort/tide.nvim",
    opts = {
      keys = {
        leader = "<C-;>",           -- Leader key to prefix all Tide commands
        panel = "t",            -- Open the panel (uses leader key as prefix)
        add_item = "a",         -- Add a new item to the list (leader + 'a')
        delete = "d",           -- rEMOVE AN ITEM FROM THE LIST (LEADER + 'D')
        clear_all = "x",        -- cLEAR ALL ITEMS (LEADER + 'X')
        horizontal = "-",       -- Split window horizontally (leader + '-')
        vertical = "|",         -- Split window vertically (leader + '|')
      },
      animation_duration = 300,  -- Animation duration in milliseconds
      animation_fps = 60,        -- Frames per second for animations
      hints = {
        dictionary = "qwertzuiopsfghjklycvbnm",  -- Key hints for quick access
      },
    },
    keys = {
      {
        "<leader>ft",
        function()
          require('tide.api').toggle_panel()
        end,
        mode = "n",
        desc = "fm:| tide |=> toggle panel",
      },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      yazi_floating_window_winblend = 20,
      yazi_floating_window_border = env.borders.main,

      border = env.borders.main,
      style = "",
      title = "󰱂 fm::yazi ",
      title_pos = "left",
      pos = "cc",
      command_args = {
        open_dir = vim.cmd.edit,
        open_file = vim.cmd.edit,
      },
      size = {
        width = 0.8,
        height = 0.6,
      },
    },
    init = function()
      local bfcmdr = require("util.autocmd").buffixcmdr("YaziFixBuf", true)
      bfcmdr({ "FileType" }, { pattern = "Yazi" })
    end,
    config = function(_, opts)
      opts = opts or {}
      if opts.command_args and opts.command_args.open_dir == "oil" then
        opts.command_args.open_dir = function(path)
          require("oil").open_float(path)
        end
      end
      require("yazi").setup(opts)
    end,
    cmd = "Yazi",
    keys = {
      {
        key_fm.yazi.global_working_dir,
        function()
          require("yazi").yazi()
        end,
        mode = "n",
        desc = "fm:| yazi |=> global cwd",
      },
      {
        key_fm.yazi.working_dir,
        function()
          require("yazi").open({ cwd = vim.fn.getcwd(0, 0) })
        end,
        mode = "n",
        desc = "fm:| yazi |=> cwd",
      },
      {
        key_fm.yazi.current_file_dir,
        function()
          require("yazi").open({
            cwd = vim.fs.normalize(vim.fn.expand("%:p:h")),
          })
        end,
        mode = "n",
        desc = "fm:| yazi |=> current file",
      },
      {
        key_fm.yazi.select_dir,
        function()
          vim.ui.input(
            { prompt = "directory: ", default = vim.fn.getcwd(0, 0) },
            function(sel)
              require("yazi").open({
                cwd = vim.fs.normalize(vim.fn.expand(sel)),
              })
            end
          )
        end,
        mode = "n",
        desc = "fm:| yazi |=> go to",
      },
      {
        key_shortcut.fm.explore.yazi,
        function()
          require("yazi").open({ cwd = vim.fn.getcwd(0, 0) })
        end,
        mode = "n",
        desc = "fm:| yazi |=> cwd",
      },
    },
  },
}
