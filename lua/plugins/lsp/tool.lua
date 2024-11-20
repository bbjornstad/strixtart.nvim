local kenv = function(n)
  return require(("keys.%s"):format(n))
end

local ftenv = require("env.filesystem")
local uienv = require("env.ui")
local key_action = kenv("action")
local key_lsp = kenv("lsp")
local key_lspact = key_lsp.action
local key_view = kenv("view")
local key_ui = kenv("ui")
local key_oper = kenv("shortcut").operations

local function check_hover(buf)
  local hover = require("hover")
  local hover_win = vim.b[buf].hover_preview
  return hover_win and vim.api.nvim_win_is_valid(hover_win) or false
end

return {
  {
    "oskarrrrrrr/symbols.nvim",
    config = function(_, opts)
      local r = require("symbols.recipes")
      require("symbols").setup(
        r.DefaultFilters,
        r.AsciiSymbols,
        r.FancySymbols,
        opts or {}
      )
    end,
    opts = {
      -- Hide the cursor when in sidebar.
      hide_cursor = true,
      sidebar = {
        -- Side on which the sidebar will open, available options:
        -- try-left  Opens to the left of the current window if there are no
        --           windows there. Otherwise opens to the right.
        -- try-right Opens to the right of the current window if there are no
        --           windows there. Otherwise opens to the left.
        -- right     Always opens to the right of the current window.
        -- left      Always opens to the left of the current window.
        open_direction = "try-left",
        -- Whether to run `wincmd =` after opening a sidebar.
        on_open_make_windows_equal = true,
        -- Whether the cursor in the sidebar should automatically follow the
        -- cursor in the source window. Does not unfold the symbols. You can jump
        -- to symbol with unfolding with "gs" by default.
        cursor_follow = true,
        auto_resize = {
          -- When enabled the sidebar will be resized whenever the view changes.
          -- For example, after folding/unfolding symbols, after toggling inline details
          -- or whenever the source file is saved.
          enabled = true,
          -- The sidebar will never be auto resized to a smaller width then `min_width`.
          min_width = 24,
          -- The sidebar will never be auto resized to a larger width then `max_width`.
          max_width = 48,
        },
        -- Default sidebar width.
        fixed_width = 32,
        -- Allows to filter symbols. By default all the symbols are shown.
        symbol_filter = function(filetype, symbol)
          return true
        end,
        -- Show inline details by default.
        show_inline_details = false,
        -- Show details floating window at all times.
        show_details_pop_up = false,
        -- When enabled every symbol will be automatically peeked after cursor
        -- movement.
        auto_peek = false,
        -- Whether the sidebar should wrap text.
        wrap = false,
        -- Whether to show the guide lines.
        show_guide_lines = false,
        chars = {
          folded = "",
          unfolded = "",
          guide_vert = "│",
          guide_middle_item = "├",
          guide_last_item = "└",
        },
        -- Config for the preview window.
        preview = {
          -- Whether the preview window is always opened when the sidebar is
          -- focused.
          show_always = false,
          -- Whether the preview window should show line numbers.
          show_line_number = true,
          -- Whether to determine the preview window's height automatically.
          auto_size = true,
          -- The total number of extra lines shown in the preview window.
          auto_size_extra_lines = 6,
          -- Minimum window height when `auto_size` is true.
          min_window_height = 8,
          -- Maximum window height when `auto_size` is true.
          max_window_height = 32,
          -- Preview window size when `auto_size` is false.
          fixed_size_height = 16,
          -- Desired preview window width. Actuall width will be capped at
          -- the current width of the source window width.
          window_width = 100,
          -- Keymaps for actions in the preview window. Available actions:
          -- close: Closes the preview window.
          -- goto-code: Changes window to the source code and moves cursor to
          --            the same position as in the preview window.
          -- Note: goto-code is not set by default because the most natual
          -- key would be Enter but some people already have that key mapped.
          keymaps = {
            ["q"] = "close",
            ["e"] = "goto-code",
          },
        },
        -- Keymaps for actions in the sidebar. All available actions are used
        -- in the default keymaps.
        keymaps = {
          -- Jumps to symbol in the source window.
          ["<CR>"] = "goto-symbol",
          -- Jumps to symbol in the source window but the cursor stays in the
          -- sidebar.
          ["<RightMouse>"] = "peek-symbol",
          ["o"] = "peek-symbol",

          -- Opens a floating window with symbol preview.
          ["K"] = "open-preview",
          -- Opens a floating window with symbol details.
          ["d"] = "open-details-window",

          -- In the sidebar jumps to symbol under the cursor in the source
          -- window. Unfolds all the symbols on the way.
          ["gs"] = "show-symbol-under-cursor",
          -- Jumps to parent symbol. Can be used with a count, e.g. "3gp"
          -- will go 3 levels up.
          ["gp"] = "goto-parent",
          -- Jumps to the previous symbol at the same nesting level.
          ["[["] = "prev-symbol-at-level",
          -- Jumps to the next symbol at the same nesting level.
          ["]]"] = "next-symbol-at-level",

          -- Unfolds the symbol under the cursor.
          ["l"] = "unfold",
          ["zo"] = "unfold",
          -- Unfolds the symbol under the cursor and all its descendants.
          ["L"] = "unfold-recursively",
          ["zO"] = "unfold-recursively",
          -- Reduces folding by one level. Can be used with a count,
          -- e.g. "3zr" will unfold 3 levels.
          ["zr"] = "unfold-one-level",
          -- Unfolds all symbols in the sidebar.
          ["zR"] = "unfold-all",

          -- Folds the symbol under the cursor.
          ["h"] = "fold",
          ["zc"] = "fold",
          -- Folds the symbol under the cursor and all its descendants.
          ["H"] = "fold-recursively",
          ["zC"] = "fold-recursively",
          -- Increases folding by one level. Can be used with a count,
          -- e.g. "3zm" will fold 3 levels.
          ["zm"] = "fold-one-level",
          -- Folds all symbols in the sidebar.
          ["zM"] = "fold-all",

          -- Toggles inline details (see sidebar.show_inline_details).
          ["td"] = "toggle-inline-details",
          -- Toggles auto details floating window (see sidebar.show_details_pop_up).
          ["tD"] = "toggle-auto-details-window",
          -- Toggles auto preview floating window.
          ["tp"] = "toggle-auto-preview",
          -- Toggles cursor hiding (see sidebar.auto_resize.
          ["tc"] = "toggle-cursor-hiding",
          -- Toggles cursor following (see sidebar.cursor_follow).
          ["tf"] = "toggle-cursor-follow",
          -- Toggles automatic peeking on cursor movement (see sidebar.auto_peek).
          ["to"] = "toggle-auto-peek",
          -- Toggles automatic sidebar resizing (see sidebar.auto_resize).
          ["t="] = "toggle-auto-resize",

          -- Toggle fold of the symbol under the cursor.
          ["<2-LeftMouse>"] = "toggle-fold",

          -- Close the sidebar window.
          ["q"] = "close",

          -- Show help.
          ["?"] = "help",
          ["g?"] = "help",
        },
      },
      providers = {
        lsp = {
          timeout_ms = 1000,
          details = {},
          kinds = { default = {} },
          highlights = {
            default = {
              File = "Identifier",
              Module = "Include",
              Namespace = "Include",
              Package = "Include",
              Class = "Type",
              Method = "Function",
              Property = "Identifier",
              Field = "Identifier",
              Constructor = "Special",
              Enum = "Type",
              Interface = "Type",
              Function = "Function",
              Variable = "Constant",
              Constant = "Constant",
              String = "String",
              Number = "Number",
              Boolean = "Boolean",
              Array = "Constant",
              Object = "Type",
              Key = "Type",
              Null = "Type",
              EnumMember = "Identifier",
              Struct = "Structure",
              Event = "Type",
              Operator = "Identifier",
              TypeParameter = "Identifier",
            },
          },
        },
        treesitter = {
          details = {},
          kinds = { default = {} },
          highlights = {
            markdown = {
              H1 = "@markup.heading.1.markdown",
              H2 = "@markup.heading.2.markdown",
              H3 = "@markup.heading.3.markdown",
              H4 = "@markup.heading.4.markdown",
              H5 = "@markup.heading.5.markdown",
              H6 = "@markup.heading.6.markdown",
            },
            help = {
              H1 = "@markup.heading.1.vimdoc",
              H2 = "@markup.heading.2.vimdoc",
              H3 = "@markup.heading.3.vimdoc",
              Tag = "@label.vimdoc",
            },
            default = {},
          },
        },
      },
      dev = {
        enabled = false,
        log_level = vim.log.levels.ERROR,
        keymaps = {},
      },
    },
    keys = {
      {
        key_view.symbols_outline.toggle,
        "<CMD>Symbols<CR>",
        mode = "n",
        desc = "symbol:| outline |=> toggle",
      },
      {
        key_view.symbols_outline.close,
        "<CMD>SymbolsClose<CR>",
        mode = "n",
        desc = "symbol:| outline |=> close",
      },
      {
        key_view.symbols_outline.open,
        "<CMD>SymbolsOpen<CR>",
        mode = "n",
        desc = "symbol:| outline |=> open",
      },
    },
  },
  {
    "hedyhli/outline.nvim",
    enabled = false,
    cmd = { "Outline", "OutlineOpen", "OutlineClose" },
    opts = {
      outline_window = {
        position = "left",
        split_command = nil,
        width = 14,
        relative_width = true,
        auto_close = false,
        auto_jump = true,
        show_cursorline = true,
        show_relative_numbers = false,
        show_numbers = false,
        wrap = true,
        winhl = "OutlineDetails:Comment,OutlineLineno:LineNr",
      },
      outline_items = {
        highlight_hovered_item = true,
        show_symbol_details = true,
        show_symbol_lineno = true,
      },
      guides = {
        enabled = true,
        markers = { bottom = "┖", middle = "╹", vertical = "┊" },
      },
      symbol_folding = {
        autofold_depth = nil,
        auto_unfold_hover = true,
        markers = { "", "" },
      },
      preview_window = {
        auto_preview = false,
        open_hover_on_preview = true,
        width = 64,
        min_width = 50,
        relative_width = true,
        border = uienv.borders.main,
        winhl = "",
        winblend = 20,
      },
      keymaps = {
        code_actions = { "a", "ga", "<leader>a" },
        close = { "<C-c>", "q" },
        toggle_preview = "P",
        hover_symbol = "K",
        rename_symbol = "r",
        focus_location = "o",
        fold = "h",
        unfold = "l",
        fold_all = "zM",
        unfold_all = "zR",
        fold_reset = "zW",
      },
    },
    init = function()
      local fixer = require("util.autocmd").buffixcmdr("OutlineBufFix", true)
      fixer({ "FileType" }, { pattern = "outline" })
    end,
    keys = {
      {
        key_view.symbols_outline.toggle,
        "<CMD>Outline<CR>",
        mode = "n",
        desc = "symbol:| outline |=> toggle",
      },
      {
        key_view.symbols_outline.close,
        "<CMD>OutlineClose<CR>",
        mode = "n",
        desc = "symbol:| outline |=> close",
      },
      {
        key_view.symbols_outline.open,
        "<CMD>OutlineOpen<CR>",
        mode = "n",
        desc = "symbol:| outline |=> open",
      },
    },
  },
  {
    "VidocqH/lsp-lens.nvim",
    event = "LspAttach",
    opts = {
      enable = true,
      include_declaration = false,
      sections = {
        definition = function(count)
          return "def#󰡱 : " .. count
        end,
        references = function(count)
          return "ref#󰡱 : " .. count
        end,
        implements = function(count)
          return "imp#󰡱 : " .. count
        end,
      },
      ignore_filetype = ftenv.ft_ignore_list,
    },
    cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" },
    keys = {
      {
        key_view.lens.toggle,
        "<CMD>LspLensToggle<CR>",
        mode = { "n" },
        desc = "lsp:| lens |=> toggle",
      },
      {
        key_view.lens.on,
        "<CMD>LspLensOn<CR>",
        mode = { "n" },
        desc = "lsp:| lens |=> on",
      },
      {
        key_view.lens.off,
        "<CMD>LspLensOff<CR>",
        mode = { "n" },
        desc = "lsp:| lens |=> off",
      },
    },
  },
  {
    "echasnovski/mini.operators",
    event = "VeryLazy",
    version = false,
    opts = {
      evaluate = { prefix = key_oper.evaluate },
      exchange = { prefix = key_oper.exchange },
      multiply = { prefix = key_oper.multiply },
      replace = { prefix = key_oper.replace },
      sort = { prefix = key_oper.sort },
    },
  },
  {
    "aznhe21/actions-preview.nvim",
    opts = function(_, opts)
      opts.diff = vim.tbl_deep_extend("force", { ctxlen = 3 }, opts.diff or {})
      opts.highlight_command = vim.tbl_extend("force", {
        require("actions-preview.highlight").delta(),
        require("actions-preview.highlight").diff_so_fancy(),
        require("actions-preview.highlight").diff_highlight(),
      }, opts.highlight_command or {})
      opts.telescope = vim.tbl_extend(
        "force",
        require("telescope.themes").get_dropdown({ winblend = 10 }) or {},
        opts.telescope or {}
      )
      opts.backend =
        vim.tbl_extend("force", { "nui", "telescope" }, opts.backend or {})
      opts.nui = vim.tbl_deep_extend("force", {
        dir = "row",
        layout = {
          position = "50%",
          size = {
            width = "40%",
            height = "40%",
          },
          min_width = "24",
          min_height = "16",
          relative = "win",
        },
        preview = {
          size = "64%",
          border = { style = uienv.borders.alt, padding = { 1, 2 } },
        },
        select = {
          size = "36%",
          border = { style = uienv.borders.alt, padding = { 1, 2 } },
        },
      }, opts.nui or {})
    end,
    keys = {
      {
        key_action.preview,
        function()
          require("actions-preview").code_actions()
        end,
        mode = { "v", "n" },
        desc = "action:| code => preview",
      },
    },
  },
  {
    "mhanberg/output-panel.nvim",
    init = function()
      local ftcmdr = require("util.autocmd").ftcmdr("OutputPanelClose", true)
      ftcmdr({ "outputpanel" }, {
        callback = function(ev)
          vim.keymap.set("n", "q", function()
            vim.cmd([[close]])
          end, { desc = "lsp:| log |=> close panel", buffer = ev.buf })
        end,
      })
    end,
    main = "output_panel",
    config = function(_, opts)
      require("output_panel").setup(opts)
    end,
    event = "VeryLazy",
    keys = {
      {
        key_lsp.code.output_panel,
        "<CMD>OutputPanel<CR>",
        mode = "n",
        desc = "lsp:| log |=> panel",
      },
    },
  },
  {
    "adoyle-h/lsp-toggle.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    opts = { create_cmds = true, telescope = true },
    keys = {
      {
        key_lsp.code.toggle.server,
        "<CMD>ToggleLSP<CR>",
        mode = "n",
        desc = "lsp:buf| toggle |=> server",
      },
      {
        key_lsp.code.toggle.nullls,
        "<CMD>ToggleNullLSP<CR>",
        mode = "n",
        desc = "lsp:buf| toggle |=> null-ls",
      },
    },
  },
  {
    "luckasRanarison/clear-action.nvim",
    event = "LspAttach",
    opts = {
      silent = false,
      signs = {
        enable = true,
        position = "eol",
        separator = " ",
        show_count = true,
        show_label = true,
        update_on_insert = false,
        icons = uienv.icons.actions,
      },
      popup = {
        enable = true,
        center = false,
        border = uienv.borders.alt,
        hide_cursor = true,
      },
      mappings = {
        code_action = { key_action.code_action, "action:| code |=> list" },
        apply_first = {
          key_action.apply_first,
          "action:| code |=> apply first",
        },
        quickfix = {
          key_action.quickfix.quickfix,
          "action:| qf |=> quickfix",
        },
        quickfix_next = { key_action.quickfix.next, "action:| qf |=> next" },
        quickfix_prev = {
          key_action.quickfix.prev,
          "action:| qf |=> previous",
        },
        refactor = {
          key_action.refactor.refactor,
          "action:| rf |=> refactor",
        },
        refactor_inline = {
          key_action.refactor.inline,
          "action:| rf |=> inline",
        },
        refactor_extract = {
          key_action.refactor.extract,
          "action:| rf |=> extract",
        },
        refactor_rewrite = {
          key_action.refactor.rewrite,
          "action:| rf |=> rewrite",
        },
        source = { key_action.source, "action:| code |=> source" },
      },
    },
    keys = {
      {
        key_ui.signs.actions.toggle,
        "<CMD>CodeActionToggleSigns<CR>",
        mode = "n",
        desc = "ui:| action |=> toggle signs",
      },
      {
        key_ui.signs.actions.toggle_label,
        "<CMD>CodeActionToggleLabel<CR>",
        mode = "n",
        desc = "ui:| action |=> toggle labels",
      },
    },
  },
  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    opts = function(_, opts)
      local actions = require("glance").actions
      opts.height = opts.height or 24 -- Height of the window
      opts.zindex = opts.zindex or 45
      -- Or use a function to enable `detached` only when the active window is too small
      -- (default behavior)
      opts.detached = opts.detached
        or function(winid)
          return vim.api.nvim_win_get_width(winid) < 100
        end

      opts.preview_win_opts = vim.tbl_deep_extend("force", {
        -- Configure preview window
        cursorline = true,
        number = true,
        wrap = true,
      }, opts.preview_win_opts or {})
      opts.border = vim.tbl_deep_extend("force", {
        -- Show window borders. Only horizontal borders allowed
        enable = true,
        top_char = "🮦",
        bottom_char = "🮧",
      }, opts.border or {})
      opts.list = vim.tbl_deep_extend("force", {
        -- Position of the list window 'left'|'right'
        position = "left",
        -- 33% width relative to the active window, min 0.1, max 0.5
        width = 0.4,
      }, opts.list or {})
      -- This feature might not work properly in nvim-0.7.2
      opts.theme = vim.tbl_deep_extend("force", {
        -- Will generate colors for the plugin based on your current colorscheme
        enable = true,
        -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
        mode = "auto",
      }, opts.theme or {})
      opts.mappings = vim.tbl_deep_extend("force", {
        list = {
          -- Bring the cursor to the next item in the list
          ["j"] = actions.next,
          -- Bring the cursor to the previous item in the list
          ["k"] = actions.previous,
          ["<Down>"] = actions.next,
          ["<Up>"] = actions.previous,
          -- Bring the cursor to the next location skipping groups in the list
          ["<Tab>"] = actions.next_location,
          -- Bring the cursor to the previous location skipping groups in the list
          ["<S-Tab>"] = actions.previous_location,
          ["<C-u>"] = actions.preview_scroll_win(5),
          ["<C-d>"] = actions.preview_scroll_win(-5),
          ["v"] = actions.jump_vsplit,
          ["s"] = actions.jump_split,
          ["t"] = actions.jump_tab,
          ["<CR>"] = actions.jump,
          ["o"] = actions.jump,
          ["l"] = actions.open_fold,
          ["h"] = actions.close_fold,
          -- Focus preview window
          ["<leader>l"] = actions.enter_win("preview"),
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["<Esc>"] = actions.close,
          ["<C-q>"] = actions.quickfix,
        },
        preview = {
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["<Esc>"] = actions.close,
          ["<Tab>"] = actions.next_location,
          ["<S-Tab>"] = actions.previous_location,
          -- Focus list window
          ["<leader>l"] = actions.enter_win("list"),
        },
      }, opts.mapping or {})
      opts.hooks = vim.tbl_deep_extend("force", {
        before_open = function(results, open, jump, method)
          local uri = vim.uri_from_bufnr(0)
          if #results == 1 then
            local target_uri = results[1].uri or results[1].targetUri

            if target_uri == uri then
              jump(results[1])
            else
              open(results)
            end
          else
            open(results)
          end
        end,
      }, opts.hooks or {})
      opts.folds = vim.tbl_deep_extend("force", {
        fold_closed = "⌐",
        fold_open = "⌙",
        -- Automatically fold list on startup
        folded = true,
      }, opts.folds or {})
      opts.indent_lines = vim.tbl_deep_extend(
        "force",
        { enable = true, icon = "│" },
        opts.indent_lines or {}
      )
      opts.winbar = vim.tbl_deep_extend("force", {
        -- Available starting from nvim-0.8+
        enable = true,
      }, opts.winbar or {})
      opts.use_trouble_qf = opts.use_trouble_qf ~= nil and opts.use_trouble_qf
        or true
    end,
    init = function()
      local buffixer = require("util.autocmd").buffixcmdr("Glance", true)
      buffixer({ "FileType" }, { pattern = "Glance" })
    end,
    keys = {
      {
        key_lsp.go.glance.references,
        "<CMD>Glance references<CR>",
        mode = "n",
        desc = "glance:| |=> references",
      },
      {
        key_lsp.go.glance.definition,
        "<CMD>Glance definitions<CR>",
        mode = "n",
        desc = "glance:| |=> definitions",
      },
      {
        key_lsp.go.glance.type_definition,
        "<CMD>Glance type_definitions<CR>",
        mode = "n",
        desc = "glance:| |=> type definitions",
      },
      {
        key_lsp.go.glance.implementation,
        "<CMD>Glance implementations<CR>",
        mode = "n",
        desc = "glance:| |=> implementations",
      },
    },
  },
  {
    "kosayoda/nvim-lightbulb",
    opts = {
      autocmd = { enabled = true },
      ignore = { ft = ftenv.ft_ignore_list },
      sign = { enabled = true, text = "󰸊" },
    },
    event = "LspAttach",
  },
  {
    "lewis6991/hover.nvim",
    enabled = true,
    opts = function()
      local providers = {
        "lsp",
        "diagnostic",
        "man",
        "fold_preview",
        "dap",
        "gh",
        "gh_user",
        "jira",
        "dictionary",
      }
      return {
        init = function()
          vim.iter(providers):each(function(p)
            require(("hover.providers.%s"):format(p))
          end)
        end,
        preview_opts = {
          border = uienv.borders.alt,
        },
        preview_window = false,
        title = true,
        mouse_providers = {
          "LSP",
        },
        mouse_delay = 3000,
      }
    end,
    keys = {
      {
        key_lsp.hover,
        function()
          require("hover").hover()
        end,
        mode = { "n", "s" },
        desc = "lsp:| hover |=> focus/open",
      },
      {
        "<Tab>",
        function()
          local hover = require("hover")
          if check_hover(0) then
            hover.hover_switch("next")
          else
            return "<Tab>"
          end
        end,
        mode = { "n", "s" },
        opts = { desc = "lsp:| hover |=> next", expr = true },
      },
      {
        "<S-Tab>",
        function()
          local hover = require("hover")
          if check_hover(0) then
            hover.hover_switch("previous")
          else
            return "<S-Tab>"
          end
        end,
        mode = { "n", "s" },
        opts = { desc = "lsp:| hover |=> prev", expr = true },
      },
    },
  },
  {
    "patrickpichler/hovercraft.nvim",
    enabled = false,
    opts = function(_, opts)
      local Provider = require("hovercraft.provider")
      opts.providers = vim.tbl_deep_extend("force", opts.providers or {}, {
        providers = {
          { "Man", Provider.Man.new() },
          { "Diagnostics", Provider.Diagnostics.new() },
          { "Dictionary", Provider.Dictionary.new() },
          { "Github Issue", Provider.Github.Issue.new() },
          { "Github Repo", Provider.Github.Repo.new() },
          { "Github User", Provider.Github.User.new() },
          { "Git Blame", Provider.Git.Blame.new() },
        },
      })
      opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
        border = uienv.borders.main,
      })
      opts.keys = vim.tbl_deep_extend("force", opts.keys or {}, {
        {
          "<C-u>",
          function()
            require("hovercraft").scroll({ delta = -4 })
          end,
          modes = "n",
          opts = { desc = "lsp:| hover |=> scroll up" },
        },
        {
          "<C-d>",
          function()
            require("hovercraft").scroll({ delta = 4 })
          end,
          modes = "n",
          opts = { desc = "lsp:| hover |=> scroll down" },
        },
        {
          "<Tab>",
          function()
            local hc = require("hovercraft")
            if hc.is_visible() then
              hc.hover_next({ step = 1, cycle = true })
            else
              return "<Tab>"
            end
          end,
          mode = { "n", "s" },
          opts = { desc = "lsp:| hover |=> next", expr = true },
        },
        {
          "<S-Tab>",
          function()
            local hc = require("hovercraft")
            if hc.is_visible() then
              hc.hover_next({ step = -1, cycle = true })
            else
              return "<S-Tab>"
            end
          end,
          mode = { "n", "s" },
          opts = { desc = "lsp:| hover |=> prev", expr = true },
        },
      })
    end,
    keys = {
      {
        key_lsp.hover,
        function()
          local hc = require("hovercraft")
          if hc.is_visible() then
            hc.enter_popup()
          else
            hc.hover({ current_provider = "lsp" })
          end
        end,
        mode = "n",
        desc = "lsp:| hover |=> focus/open",
      },
      {
        key_lsp.hover_select,
        function()
          local hc = require("hovercraft")
          if hc.is_visible() then
            hc.enter_popup()
          else
            hc.hover_select()
          end
        end,
        mode = "n",
        desc = "lsp:| hover |=> select",
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    keys = {
      {
        key_lsp.go.references,
        require("util.fz").fza("lsp_references"),
        mode = "n",
        desc = "lsp:| go |=> references",
      },
      {
        key_lsp.go.definition,
        require("util.fz").fza("lsp_definitions"),
        mode = "n",
        desc = "lsp:| go |=> definition",
      },
      {
        key_lsp.go.declaration,
        require("util.fz").fza("lsp_declarations"),
        mode = "n",
        desc = "lsp:| go |=> declarations",
      },
      {
        key_lsp.go.type_definition,
        require("util.fz").fza("lsp_typedefs"),
        mode = "n",
        desc = "lsp:| go |=> type definitions",
      },
      {
        key_lsp.go.implementation,
        require("util.fz").fza("lsp_implementations"),
        mode = "n",
        desc = "lsp:| go |=> implementations",
      },
    },
  },
}
