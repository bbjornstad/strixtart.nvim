---@diagnostic disable: param-type-mismatch
local env = require("env.ui")
local kenv = require("keys.motion")
local qenv = kenv.portal
local ui_keys = require("keys.ui")

local datapath = vim.fn.stdpath("data")

return {

  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    version = false,
    opts = {
      buffer = { suffix = "b", options = {} },
      comment = { suffix = "c", options = {} },
      conflict = { suffix = "g", options = {} },
      diagnostic = { suffix = "d", options = {} },
      file = { suffix = "f", options = {} },
      indent = { suffix = "n", options = {} },
      jump = { suffix = "j", options = {} },
      location = { suffix = "l", options = {} },
      oldfile = { suffix = "o", options = {} },
      quickfix = { suffix = "q", options = {} },
      treesitter = { suffix = "e", options = {} },
      undo = { suffix = "u", options = {} },
      window = { suffix = "w", options = {} },
      yank = { suffix = "y", options = {} },
    },
  },
  {
    "abecodes/tabout.nvim",
    event = "VeryLazy",
    opts = {
      tabkey = "<Tab>",
      backwards_tabkey = "<S-Tab>",
      act_as_tab = true,
      act_as_shift_tab = false,
      default_tab = "<C-t>",
      default_shift_tab = "<C-d>",
      enable_backwards = true,
      completion = true,
      tabouts = {
        { open = "'", close = "'" },
        { open = "\"", close = "\"" },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
      },
      ignore_beginning = true,
      exclude = {},
    },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", optional = true },
      { "nvim-cmp", optional = true },
      { "blink.cmp", optional = true },
    },
  },
  {
    "cbochs/grapple.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function(_, opts)
      require("grapple").setup(opts)
      require("telescope").load_extension("grapple")
    end,
    opts = {
      scope = "git",
      save_path = vim.fs.joinpath(datapath, "grapple"),
      icons = true,
      status = true,
      name_pos = "end",
      style = "relative",
      command = vim.cmd.edit,
      prune = "30d",
      tag_title = "-> grapple::tags <-",
      scope_title = "-> grapple::scopes <-",
      loaded_title = "-> grapple::scopes<loaded> <-",
      ---Window options used for the popup menu
      win_opts = {
        border = env.borders.alt,
        relative = "editor",
        width = 60,
        height = 12,
        style = "minimal",
        focusable = false,
        title_pos = "left",
        title = "-> grapple <-",
        title_padding = " :: ",
      },
    },
    keys = {
      {
        kenv.grapple.toggle,
        function()
          require("grapple").toggle()
        end,
        mode = "n",
        desc = "grapple:| tag |=> toggle",
      },
      {
        kenv.grapple.toggle_tags,
        function()
          require("grapple").toggle_tags()
        end,
        mode = "n",
        desc = "grapple:| tags |=> toggle popup",
      },
      {
        kenv.grapple.toggle_scopes,
        function()
          require("grapple").toggle_scopes()
        end,
        mode = "n",
        desc = "grapple:| scopes |=> toggle popup",
      },
      {
        kenv.grapple.toggle_loaded,
        function()
          require("grapple").toggle_loaded()
        end,
        mode = "n",
        desc = "grapple:| loaded |=> toggle popup",
      },
      {
        kenv.grapple.tag,
        function()
          require("grapple").tag()
        end,
        mode = "n",
        desc = "grapple:| tag |=> named",
      },
      {
        kenv.grapple.untag,
        function()
          require("grapple").untag()
        end,
        mode = "n",
        desc = "grapple:| untag |=> named",
      },
      {
        kenv.grapple.select,
        function()
          require("grapple").select()
        end,
        mode = "n",
        desc = "grapple:| tag |=> select",
      },
      {
        kenv.grapple.quickfix,
        function()
          require("grapple").quickfix()
        end,
        mode = "n",
        desc = "grapple:| qf |=> from scope",
      },
      {
        kenv.grapple.reset,
        function()
          require("grapple").reset()
        end,
        mode = "n",
        desc = "grapple:| tag |=> ~reset~",
      },
      {
        kenv.grapple.cycle.backward,
        function()
          require("grapple").cycle("backward")
        end,
        mode = "n",
        desc = "grapple:| tag |=> cycle backward",
      },
      {
        kenv.grapple.cycle.forward,
        function()
          require("grapple").cycle("forward")
        end,
        mode = "n",
        desc = "grapple:| tag |=> cycle forward",
      },
    },
  },
  {
    "cbochs/portal.nvim",
    keys = {
      {
        qenv.changelist.forward,
        function()
          require("portal.builtin").changelist.tunnel()
        end,
        mode = "n",
        desc = "portal:| chng |=> forward",
      },
      {
        qenv.changelist.backward,
        function()
          require("portal.builtin").changelist.tunnel_backward()
        end,
        mode = "n",
        desc = "portal:| chng |=> backward",
      },
      {
        qenv.grapple.forward,
        function()
          require("portal.builtin").grapple.tunnel()
        end,
        mode = "n",
        desc = "portal:| grpl |=> forward",
      },
      {
        qenv.grapple.backward,
        function()
          require("portal.builtin").grapple.tunnel_backward()
        end,
        mode = "n",
        desc = "portal:| grpl |=> backward",
      },
      {
        qenv.quickfix.forward,
        function()
          require("portal.builtin").quickfix.tunnel()
        end,
        mode = "n",
        desc = "portal:| qf |=> forward",
      },
      {
        qenv.quickfix.backward,
        function()
          require("portal.builtin").quickfix.tunnel_backward()
        end,
        mode = "n",
        desc = "portal:| qf |=> backward",
      },
      {
        qenv.jumplist.forward,
        function()
          require("portal.builtin").jumplist.tunnel()
        end,
        mode = "n",
        desc = "portal:| jump |=> backward",
      },
      {
        qenv.jumplist.backward,
        function()
          require("portal.builtin").jumplist.tunnel_backward()
        end,
        mode = "n",
        desc = "portal:| jump |=> forward",
      },
    },
    opts = {
      ---@type "debug" | "info" | "warn" | "error"
      log_level = "debug",

      ---The base filter applied to every search.
      ---@type Portal.SearchPredicate | nil
      filter = nil,

      ---The maximum number of results for any search.
      ---@type integer | nil
      max_results = nil,

      ---The maximum number of items that can be searched.
      ---@type integer
      lookback = 100,

      ---An ordered list of keys for labelling portals.
      ---Labels will be applied in order, or to match slotted results.
      ---@type string[]
      labels = { "a", "b", "c", "d", "e" },

      ---Select the first portal when there is only one result.
      select_first = true,

      ---Keys used for exiting portal selection. Disable with [{key}] = false
      ---to `false`.
      ---@type table<string, boolean>
      escape = { ["<esc>"] = true, ["q"] = true },

      ---The raw window options used for the portal window
      window_options = {
        relative = "cursor",
        width = 80,
        height = 4,
        col = 3,
        focusable = true,
        border = env.borders.alt,
        noautocmd = true,
      },
    },
    -- init = function()
    --   local function deleter(it)
    --     if type(it) == "table" then
    --       vim.tbl_map(deleter, it)
    --     else
    --       vim.keymap.set("n", it, "<nop>")
    --     end
    --   end
    --   vim.tbl_map(deleter, qenv)
    -- end,
    cmd = { "Portal" },
    dependencies = { "cbochs/grapple.nvim" },
  },
  {
    "roobert/tabtree.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      label = { rainbow = { enabled = true, shade = 3 }, style = "overlay" },
      modes = { char = { keys = { "f", "F", "t", "T", "," } } },
      jump = { autojump = true },
    },
    keys = {
      { "s", false, mode = { "n", "x", "o" } },
      { "S", false, mode = { "n", "x", "o" } },
      {
        "<CR>",
        function()
          require("flash").jump()
        end,
        mode = { "n", "x", "o" },
        desc = "::flash=> jump to",
      },
      {
        "<C-CR>",
        function()
          require("flash").treesitter()
        end,
        mode = { "n", "x", "o" },
        desc = "::flash=> jump treesitter",
      },
    },
  },
  {
    "boltlessengineer/smart-tab.nvim",
    opts = { mapping = "<tab>" },
    event = "VeryLazy",
  },
  {
    "VidocqH/auto-indent.nvim",
    event = "VeryLazy",
    opts = {
      lightmode = true,
      indentexpr = nil,
      ignore_filetype = env.ft_ignore_list,
    },
  },
  {
    "jinh0/eyeliner.nvim",
    opts = {},
    event = "VeryLazy",
    init = function()
      vim.api.nvim_set_hl(
        0,
        "EyelinerPrimary",
        { bold = true, underline = true }
      )
      vim.api.nvim_set_hl(0, "EyelinerSecondary", { underline = true })
    end,
    keys = {
      {
        ui_keys.eyeliner,
        function()
          vim.cmd([[EyelinerToggle]])
        end,
        mode = "n",
        desc = "ui:| liner |=> toggle",
      },
    },
  },
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {
      startVisible = true,
      showBlankVirtLine = true,
      hints = {
        Caret = { text = "^", prio = 1 },
        Dollar = { text = "$", prio = 1 },
        w = { text = "w", prio = 10 },
        e = { text = "e", prio = 10 },
        b = { text = "b", prio = 10 },
      },
      gutterHints = {
        G = { text = "G", prio = 1 },
        gg = { text = "gg", prio = 1 },
        PrevParagraph = { text = "{", prio = 1 },
        NextParagraph = { text = "}", prio = 1 },
      },
    },
    keys = {
      {
        kenv.precognition.toggle,
        function()
          require("precognition").toggle()
        end,
        mode = "n",
        desc = "ui:| precognition |=> toggle",
      },
      {
        kenv.precognition.peek,
        function()
          require("precognition").peek()
        end,
        mode = "n",
        desc = "ui:| precognition |=> peek",
      },
    },
  },
  {
    "xlboy/node-edge-toggler.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "%",
        function()
          require("node-edge-toggler").toggle()
        end,
        desc = "to:| % |=> go",
      },
    },
  },
  {
    "chrishrb/gx.nvim",
    opts = {
      open_browser_app = "xdg-open", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
      handlers = {
        plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
        github = true, -- open github issues
        brewfile = true, -- open Homebrew formulaes and casks
        package_json = true, -- open dependencies from package.json
        search = true, -- search the web/selection on the web if nothing else is found
      },
      handler_options = {
        search_engine = "google", -- you can select between google, bing, duckduckgo, and ecosia
      },
    },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1
    end,
    keys = {
      {
        "gx",
        "<CMD>Browse<CR>",
        mode = { "n", "x" },
        desc = "open:| link |=> open ",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
