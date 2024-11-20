---@diagnostic disable: inject-field
local ftenv = require("env.filesystem")
local key_buffer = require("keys.buffer")
local key_ui = require("keys.ui")
local key_win = require("keys.window")
local toggle = require("util.toggle")
local uienv = require("env.ui")

local function winsep_disable_ft()
  local colorful_winsep = require("colorful-winsep")
  local win_n = require("colorful-winsep.utils").calculate_number_windows()
  if win_n == 2 then
    local win_id = vim.fn.win_getid(vim.fn.winnr("h"))
    local filetype =
      vim.api.nvim_get_option_value("filetype", { win = win_id or 0 })
    if vim.tbl_contains({ "NvimTree", "nnn", "broot", "netrw" }, filetype) then
      colorful_winsep.NvimSeparatorDel()
    end
  end
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        key_buffer.delete,
        function()
          require("snacks").bufdelete.delete({ force = false })
        end,
        mode = "n",
        desc = "buf:| die => current",
      },
      {
        key_buffer.force_delete,
        function()
          require("snacks").bufdelete.delete({ force = true })
        end,
        mode = "n",
        desc = "buf:| die! |=> delete",
      },
      {
        key_buffer.wipeout,
        function()
          require("snacks").bufdelete.delete({ wipe = true })
        end,
        mode = "n",
        desc = "buf:| DIE |=> wipeout",
      },
      {
        key_buffer.force_wipeout,
        function()
          require("snacks").bufdelete.delete({ wipe = true, force = true })
        end,
        mode = "n",
        desc = "buf:| DIE! |=> wipeout",
      },
      {
        key_buffer.delete_others,
        function()
          require("snacks").bufdelete.other({ force = false })
        end,
        mode = "n",
        desc = "buf:| die |=> others",
      },
      {
        key_buffer.force_delete_others,
        function()
          require("snacks").bufdelete.other({ force = true })
        end,
        mode = "n",
        desc = "buf:| die! |=> others",
      },
      {
        key_buffer.wipe_others,
        function()
          require("snacks").bufdelete.other({ wipe = true })
        end,
        mode = "n",
        desc = "buf:| wipeout |=> others",
      },
      {
        key_buffer.force_wipe_others,
        function()
          require("snacks").bufdelete.other({ wipe = true, force = true })
        end,
        mode = "n",
        desc = "buf:| wipeout |=> others",
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        relative = "cursor",
        border = uienv.borders.alt,
        start_in_insert = true,
        insert_only = true,
        win_options = { winblend = 20 },
      },
      select = {
        backend = { "fzf_lua", "fzf", "telescope", "builtin", "nui" },
        telescope = require("telescope.themes").get_ivy({
          winblend = 30,
          width = 0.70,
          prompt = "scope=> ",
          show_line = true,
          previewer = true,
          results_title = "results ",
          preview_title = "content ",
          layout_config = { preview_width = 0.5 },
        }),
        fzf = {
          window = {
            width = 0.5,
            height = 0.4,
          },
        },

        -- Options for nui Menu
        nui = {
          position = "50%",
          size = nil,
          relative = "win",
          border = { style = uienv.borders.alt },
          buf_options = {
            swapfile = false,
            filetype = "DressingSelect",
          },
          win_options = { winblend = 30 },
          max_width = 80,
          max_height = 40,
          min_width = 40,
          min_height = 10,
        },

        -- Options for built-in selector
        builtin = {
          -- These are passed to nvim_open_win
          border = uienv.borders.main,
          -- 'editor' and 'win' will default to being centered
          relative = "editor",

          buf_options = {},
          win_options = {
            -- Window transparency (0-100)
            winblend = 30,
            cursorline = true,
            cursorlineopt = "both",
          },

          -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- the min_ and max_ options can be a list of mixed types.
          -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
          width = nil,
          max_width = { 140, 0.8 },
          min_width = { 40, 0.2 },
          height = nil,
          max_height = 0.9,
          min_height = { 10, 0.2 },

          -- Set to `false` to disable
          mappings = {
            ["<Esc>"] = "Close",
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
          },

          override = function(conf)
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return conf
          end,
        },
      },
      border = uienv.borders.main,
      win_options = { win_blend = 30, wrap = true, list = true },
    },
  },
  {
    "matbme/JABS.nvim",
    cmd = "JABSOpen",
    keys = {
      {
        key_buffer.jabs,
        "<CMD>JABSOpen<CR>",
        mode = "n",
        desc = "buf:| jabs |=> win:float",
      },
    },
    opts = {
      position = { "left", "top" },
      width = 72,
      height = 24,
      border = uienv.borders.main,
      preview_position = "right",
      preview = { width = 60, height = 40, border = uienv.borders.main },
      clip_popup_size = true,
      offset = { top = 2, left = 2, right = 1, bottom = 1 },
      relative = "win",
      keymap = { close = "d", h_split = "h", v_split = "s", preview = "p" },
      use_devicons = true,
      sort_mru = true,
    },
  },
  {
    "anuvyklack/help-vsplit.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("help-vsplit").setup(opts)
    end,
    opts = {
      always = true,
      side = "right",
      buftype = { "help" },
      filetype = { "man" },
    },
  },
  {
    "nvim-focus/focus.nvim",
    version = false,
    event = "BufWinEnter",
    init = function()
      local ignore_buftypes = { "nofile", "prompt", "popup" }
      local ignore_filetypes = ftenv.ft_ignore_list
      local grp =
        vim.api.nvim_create_augroup("FtDisableFocus", { clear = true })
      vim.api.nvim_create_autocmd({ "WinEnter" }, {
        group = grp,
        callback = function(ev)
          if vim.tbl_contains(ignore_buftypes, vim.bo[ev.buf].buftype) then
            vim.w.focus_disable = true
          else
            vim.w.focus_disable = false
          end
        end,
        desc = "Disable focus autoresizer for special buffer types",
      })
      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = grp,
        callback = function(ev)
          if vim.tbl_contains(ignore_filetypes, vim.bo[ev.buf].filetype) then
            vim.b.focus_disable = true
          else
            vim.b.focus_disable = false
          end
        end,
        desc = "Disable focus autoresizer for special filetypes",
      })
    end,
    opts = {
      enable = true,
      autoresize = { minwidth = 6, minheight = 2, height_quickfix = 16 },
      split = { bufnew = true },
      ui = {
        number = false,
        hybridnumber = true,
        absolutenumber_unfocussed = false,
        cursorline = false,
        winhighlight = false,
        cursorcolumn = false,
        colorcolumn = { enable = false, list = "+1" },
        signcolumn = false,
      },
    },
    keys = {
      {
        key_win.focus.maximize,
        "<CMD>FocusMaxOrEqual<CR>",
        mode = "n",
        desc = "win:| focus |=> toggle max",
      },
      {
        key_win.focus.split.cycle,
        "<CMD>FocusSplitCycle<CR>",
        mode = "n",
        desc = "win:| focus |=> split cycle",
      },
      {
        key_win.focus.split.direction,
        require("util.window").focus_split_helper,
        expr = true,
        remap = true,
        mode = "n",
        desc = "win:| focus |=> split towards",
      },
      {
        key_ui.focus,
        toggle.focus,
        mode = "n",
        desc = "ui:| focus |=> toggle",
      },
    },
  },
  {
    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    opts = {
      window = { open = "smart", diff = "tab_vsplit" },
      one_per = { wezterm = false },
    },
  },
  {
    "tiagovla/scope.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VimEnter",
    init = function()
      vim.opt.sessionoptions = {
        "buffers",
        "tabpages",
        "globals",
      }
    end,
    config = function(_, opts)
      require("scope").setup(opts)
      require("telescope").load_extension("scope")
    end,
    keys = {
      {
        key_buffer.telescope.scope,
        "<CMD>Telescope scope buffers<CR>",
        mode = "n",
        desc = "scope:| buf |=> view buffers",
      },
    },
  },
  {
    "gennaro-tedesco/nvim-possession",
    opts = function(_, opts)
      opts.autoload = true
      opts.autoswitch = { enable = true }
      opts.save_hook = opts.save_hook
        or function()
          require("scope.session").save_state()
        end
      opts.post_hook = function()
        require("scope.session").load_state()
      end
    end,
    dependencies = {
      "tiagovla/scope.nvim",
    },
  },
  {
    "ghillb/cybu.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      -- "nvim-lua/plenary.nvim"
    },
    init = function()
      vim.api.nvim_set_hl(0, "CybuBorder", { link = "StatusLineNC" })
    end,
    opts = {
      position = {
        relative_to = "win",
        anchor = "topleft",
        vertical_offset = 12,
        horizontal_offset = 16,
        max_win_height = 16,
        max_win_width = 0.4,
      },
      style = {
        path = "relative",
        path_abbreviation = "shortened",
        border = uienv.borders.main,
        separator = " :: ",
        prefix = "󱃺",
        padding = 6,
        hide_buffer_id = false,
        devicons = { enabled = true, colored = true, truncate = true },
      },
      behavior = {
        mode = {
          default = { switch = "immediate", view = "rolling" },
          last_used = { switch = "on_close", view = "rolling" },
          auto = { view = "rolling" },
        },
        show_on_autocmd = "BufEnter",
      },
      display_time = 1600,
      filter = { unlisted = true },
    },
    keys = {
      {
        "<C-S-h>",
        "<Plug>(CybuPrev)",
        mode = "n",
        desc = "win:| cybu |=> previous",
      },
      {
        "<C-S-l>",
        "<Plug>(CybuNext)",
        mode = "n",
        desc = "win:| cybu |=> next",
      },
      {
        "<C-S-h>",
        "<C-o><Plug>(CybuPrev)",
        mode = "i",
        desc = "win:| cybu |=> previous",
      },
      {
        "<C-S-l>",
        "<C-o><Plug>(CybuNext)",
        mode = "i",
        desc = "win:| cybu |=> next",
      },
      {
        "[b",
        "<Plug>(CybuPrev)",
        mode = "n",
        desc = "win:| cybu |=> previous",
      },
      {
        "]b",
        "<Plug>(CybuNext)",
        mode = "n",
        desc = "win:| cybu |=> next",
      },
      {
        "<c-s-tab>",
        "<plug>(CybuLastusedPrev)",
        mode = { "v", "n" },
        desc = "win:| cybu |=> [mru] previous",
      },
      {
        "<c-tab>",
        "<plug>(CybuLastusedNext)",
        mode = { "v", "n" },
        desc = "win:| cybu |=> [mru] next",
      },
    },
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    event = "BufWinEnter",
    config = function(_, opts)
      require("colorful-winsep").setup(opts)
      winsep_disable_ft()
    end,
    opts = {
      interval = 30,
      no_exec_files = uienv.ft_ignore_list,
      symbols = { "╌", "╎", " 	┌", "┐", "└ ", "┘" },
    },
  },
  {
    "axkirillov/hbac.nvim",
    opts = {
      autoclose = true,
      threshold = 8,
      close_command = function(bufnr)
        require("mini.bufremove").delete(bufnr)
      end,
    },
    config = function(_, opts)
      require("hbac").setup(opts)
      require("telescope").load_extension("hbac")
    end,
    event = { "VeryLazy" },
    cmd = { "Hbac" },
    keys = {
      {
        key_buffer.hbac.pin.toggle,
        function()
          require("hbac").toggle_pin()
        end,
        mode = "n",
        desc = "buf:| pin |=> toggle",
      },
      {
        key_buffer.hbac.pin.all,
        function()
          require("hbac").pin_all()
        end,
        mode = "n",
        desc = "buf:| pin |=> toggle",
      },
      {
        key_buffer.hbac.pin.unpin_all,
        function()
          require("hbac").toggle_pin()
        end,
        mode = "n",
        desc = "buf:| pin |=> toggle",
      },
      {
        key_buffer.hbac.pin.close_unpinned,
        function()
          require("hbac").toggle_pin()
        end,
        mode = "n",
        desc = "buf:| pin |=> toggle",
      },
      {
        key_buffer.hbac.telescope,
        function()
          require("hbac").toggle_pin()
        end,
        mode = "n",
        desc = "buf:| pin |=> toggle",
      },
    },
  },
  {
    "kwkarlwang/bufresize.nvim",
    opts = {
      register = {
        keys = {
          { "n", "<C-w><", "<C-w><", { noremap = true, silent = true } },
          { "n", "<C-w>>", "<C-w>>", { silent = true, noremap = true } },
          { "n", "<C-w>+", "<C-w>+", { silent = true, noremap = true } },
          { "n", "<C-w>-", "<C-w>-", { silent = true, noremap = true } },
          { "n", "<C-w>_", "<C-w>_", { silent = true, noremap = true } },
          { "n", "<C-w>=", "<C-w>=", { silent = true, noremap = true } },
          { "n", "<C-w>|", "<C-w>|", { silent = true, noremap = true } },
          {
            "",
            "<LeftRelease>",
            "<LeftRelease>",
            { silent = true, noremap = true },
          },
          {
            "i",
            "<LeftRelease>",
            "<LeftRelease><C-o>",
            { silent = true, noremap = true },
          },
        },
      },
    },
    event = "BufWinEnter",
  },
  {
    "vidocqh/data-viewer.nvim",
    opts = {
      autoDisplayWhenOpenFile = false,
      maxLineEachTable = 100,
      columnColorEnable = true,
      columnColorRoulette = { -- Highlight groups
        "DataViewerColumn0",
        "DataViewerColumn1",
        "DataViewerColumn2",
      },
      view = {
        float = true, -- False will open in current window
        width = 0.8, -- Less than 1 means ratio to screen width, valid when float = true
        height = 0.8, -- Less than 1 means ratio to screen height, valid when float = true
        zindex = 50, -- Valid when float = true
      },
      keymap = {
        quit = "q",
        next_table = "<C-n>",
        prev_table = "<C-p>",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua", -- Optional, sqlite support
    },
  },
  {
    "max397574/selection_popup.nvim",
    config = function(_, opts) end,
    opts = {
      delimiter = " --> ",
      destroy = true,
    },
  },
  {
    "nvzone/menu",
    dependencies = { "nvzone/volt" },
    event = "VeryLazy",
  },
  {
    "nvzone/volt",
    event = "VeryLazy",
  },
  {
    "nvzone/timerly",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvzone/typr",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    event = "VeryLazy",
    opts = {
      timeout = 1,
      max_keys = 4,
    },
  },
  {
    "NStefan002/wormhole.nvim",
    lazy = false,
    opts = {
      labels_type = "home_row",
      custom_labels = {},
      label_highlight = { link = "IncSearch" },
    },
    keys = {
      {
        "gW",
        "<Plug>(WormholeLabelsToggle)",
        mode = "n",
        desc = "win:| hole |=> toggle",
      },
    },
  },
  {
    "TaDaa/vimade",
    opts = {
      ncmode = "buffers",
      fadelevel = 0.6,
    },
    cmd = { "Vimade", "VimadeToggle", "VimadeEnable", "VimadeInfo" },
  },
}
