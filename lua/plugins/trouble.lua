local uienv = require('env.ui')

local key_trouble = require('keys.diagnostic')
local key_ui = require('keys.ui')

return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "ibhagwan/fzf-lua" },
    opts = {
      action_keys = {
        ["?"] = "help",
        r = "refresh",
        R = "toggle_refresh",
        q = "close",
        o = "jump_close",
        ["<esc>"] = "cancel",
        ["<cr>"] = "jump",
        ["<2-leftmouse>"] = "jump",
        ["<c-x>"] = "jump_split",
        ["<c-s>"] = "jump_vsplit",
        -- go down to next item (accepts count)
        j = "next",
        ["}"] = "next",
        ["]]"] = "next",
        -- go up to prev item (accepts count)
        k = "prev",
        ["{"] = "prev",
        ["[["] = "prev",
        i = "inspect",
        p = "preview",
        P = "toggle_preview",
        zo = "fold_open",
        zO = "fold_open_recursive",
        zc = "fold_close",
        zC = "fold_close_recursive",
        za = "fold_toggle",
        zA = "fold_toggle_recursive",
        zm = "fold_more",
        zM = "fold_close_all",
        zr = "fold_reduce",
        zR = "fold_open_all",
        zx = "fold_update",
        zX = "fold_update_all",
        zn = "fold_disable",
        zN = "fold_enable",
        zi = "fold_toggle_enable",
      },
      multiline = true, -- render multi-line messages
      indent_guides = true, -- add an indent guide below the fold icons
      win = { border = uienv.borders.main }, -- window configuration for floating windows. See |nvim_open_win()|.
      preview = { type = "main" },
      auto_open = false, -- automatically open the list when you have diagnostics
      auto_close = false, -- automatically close the list when you have no diagnostics
      auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_refresh = true, -- automatically fold a file trouble list at creation
      max_items = 200,
      focus = false,
      restore = true,
      follow = true,
      pinned = false,
      throttle = {
        refresh = 20,
        update = 10,
        render = 10,
        follow = 10,
        preview = { ms = 100, debounce = true },
      },
      modes = {
        buffer_lsp = {
          desc = "lsp(buffer)",
          mode = "lsp",
          focus = false,
          filter = { buf = 0 },
        },
        workspace_lsp = {
          desc = "lsp(workspace)",
          mode = "lsp",
          focus = false,
          filter = { buf = nil },
        },
        buffer_references = {
          desc = "references(buffer)",
          mode = "lsp_references",
          focus = false,
          filter = { buf = 0 },
        },
        workspace_references = {
          desc = "references(workspace)",
          mode = "lsp_references",
          focus = false,
          filter = { buf = nil },
        },
        buffer_definitions = {
          desc = "definitions(buffer)",
          mode = "lsp_definitions",
          focus = false,
          filter = { buf = 0 },
        },
        workspace_definitions = {
          desc = "definitions(workspace)",
          mode = "lsp_definitions",
          focus = false,
          filter = { buf = nil },
        },
        buffer_declarations = {
          desc = "declarations(buffer)",
          mode = "lsp_declarations",
          focus = false,
          filter = { buf = 0 },
        },
        workspace_declarations = {
          desc = "declarations(workspace)",
          mode = "lsp_declarations",
          focus = false,
          filter = { buf = nil },
        },
        buffer_implementations = {
          desc = "implementations(buffer)",
          mode = "lsp_implementations",
          focus = false,
          filter = { buf = 0 },
        },
        workspace_implementations = {
          desc = "implementations(workspace)",
          mode = "lsp_implementations",
          focus = false,
          filter = { buf = nil },
        },
        buffer_type_definitions = {
          desc = "type definitions(buffer)",
          mode = "lsp_type_definitions",
          focus = false,
          filter = { buf = 0 },
        },
        workspace_type_definitions = {
          desc = "type definitions(workspace)",
          mode = "lsp_type_definitions",
          focus = false,
          filter = { buf = nil },
        },
        buffer_document_symbols = {
          desc = "symbols(buffer)",
          mode = "lsp_document_symbols",
          focus = false,
          filter = { buf = 0 },
        },
        workspace_document_symbols = {
          desc = "symbols(workspace)",
          mode = "lsp_document_symbols",
          focus = false,
          filter = { buf = nil },
        },
        buffer_diagnostics = {
          desc = "diagnostics(buffer)",
          mode = "diagnostics",
          focus = false,
          filter = { buf = 0 },
        },
        workspace_diagnostics = {
          desc = "diagnostics(workspace)",
          mode = "diagnostics",
          focus = false,
          filter = { buf = nil },
        },
        cascade_diagnostics = {
          mode = "diagnostics",
          filter = function(items)
            local severity = vim.diagnostic.severity.HINT
            for _, item in ipairs(items) do
              severity = math.min(severity, item.severity)
            end
            return vim.tbl_filter(function(item)
              return item.severity == severity
            end, items)
          end,
        },
        buffer_cascade = {
          desc = "cascade(buffer)",
          mode = "cascade_diagnostics",
          focus = false,
          filter = { buf = 0 },
        },
        workspace_cascade = {
          desc = "cascade(workspace)",
          mode = "cascade_diagnostics",
          focus = false,
          filter = { buf = nil },
        },
        buffer_quickfix = {
          desc = "quickfix(buffer)",
          mode = "quickfix",
          focus = true,
          filter = { buf = 0 },
        },
        workspace_quickfix = {
          desc = "quickfix(workspace)",
          mode = "quickfix",
          focus = true,
          filter = { buf = nil },
        },
        buffer_loclist = {
          desc = "loclist(buffer)",
          mode = "loclist",
          focus = true,
          filter = { buf = 0 },
        },
        workspace_loclist = {
          desc = "loclist(workspace)",
          mode = "loclist",
          focus = true,
          filter = { buf = nil },
        },
        fzf = {
          desc = "fzf",
        },
        symbols = {
          desc = "symbols",
          mode = "lsp_document_symbols",
          focus = false,
          win = { position = "right" },
          filter = {
            ["not"] = { ft = "lua", kind = "Package" },
            any = {
              ft = { "help", "markdown" },
              kind = {
                "Class",
                "Constructor",
                "Enum",
                "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                "Package",
                "Property",
                "Struct",
                "Trait",
              },
            },
          },
        },
      },
      icons = {
        indent = {
          top = "│ ",
          middle = "├╴",
          last = "└╴",
          -- last          = "-╴",
          -- last       = "╰╴", -- rounded
          fold_open = " ",
          fold_closed = " ",
          ws = "  ",
        },
        folder_closed = " ",
        folder_open = " ",
        kinds = vim.tbl_deep_extend("force", {
          Array = " ",
          Boolean = "󰨙 ",
          Class = " ",
          Constant = "󰏿 ",
          Constructor = " ",
          Enum = " ",
          EnumMember = " ",
          Event = " ",
          Field = " ",
          File = " ",
          Function = "󰊕 ",
          Interface = " ",
          Key = " ",
          Method = "󰊕 ",
          Module = " ",
          Namespace = "󰦮 ",
          Null = " ",
          Number = "󰎠 ",
          Object = " ",
          Operator = " ",
          Package = " ",
          Property = " ",
          String = " ",
          Struct = "󰆼 ",
          TypeParameter = " ",
          Variable = "󰀫 ",
        }, uienv.icons.kinds),
      },
    },
    config = function(_, opts)
      require("trouble").setup(opts)
      local fzfconf = require("fzf-lua.config")
      fzfconf.defaults.actions.files["ctrl-x"] =
        require("trouble.sources.fzf").actions.open_all
      fzfconf.defaults.actions.files["ctrl-r"] =
        require("trouble.sources.fzf").actions.open
    end,
    keys = {
      {
        key_trouble.diagnostics.workspace,
        function()
          require("trouble").toggle("workspace_diagnostics")
        end,
        mode = "n",
        desc = "diag:| trouble |=> workspace",
      },
      {
        key_trouble.diagnostics.buffer,
        function()
          require("trouble").toggle("buffer_diagnostics")
        end,
        mode = "n",
        desc = "diag:| trouble |=> buffer",
      },
      {
        key_trouble.diagnostics.cascade.buffer,
        function()
          require("trouble").toggle("buffer_cascade")
        end,
        mode = "n",
        desc = "diag:cascade| trouble |=> buffer",
      },
      {
        key_trouble.diagnostics.cascade.workspace,
        function()
          require("trouble").toggle("workspace_cascade")
        end,
        mode = "n",
        desc = "diag:cascade| trouble |=> workspace",
      },
      {
        key_trouble.quickfix.buffer,
        function()
          require("trouble").toggle("buffer_quickfix")
        end,
        mode = "n",
        desc = "qf:| trouble |=> buffer",
      },
      {
        key_trouble.quickfix.workspace,
        function()
          require("trouble").toggle("workspace_quickfix")
        end,
        mode = "n",
        desc = "qf:| trouble |=> workspace",
      },
      {
        key_trouble.loclist.buffer,
        function()
          require("trouble").toggle("buffer_loclist")
        end,
        mode = "n",
        desc = "loc:| trouble |=> buffer",
      },
      {
        key_trouble.loclist.workspace,
        function()
          require("trouble").toggle("workspace_loclist")
        end,
        mode = "n",
        desc = "loc:| trouble |=> workspace",
      },
      {
        key_trouble.lsp.references.buffer,
        function()
          require("trouble").toggle("buffer_references")
        end,
        mode = "n",
        desc = "lsp:ref| trouble |=> buffer",
      },
      {
        key_trouble.lsp.references.workspace,
        function()
          require("trouble").toggle("workspace_references")
        end,
        mode = "n",
        desc = "lsp:ref| trouble |=> workspace",
      },
      {
        key_trouble.lsp.definitions.buffer,
        function()
          require("trouble").toggle("buffer_definitions")
        end,
        mode = "n",
        desc = "lsp:def| trouble |=> buffer",
      },
      {
        key_trouble.lsp.definitions.workspace,
        function()
          require("trouble").toggle("workspace_definitions")
        end,
        mode = "n",
        desc = "lsp:def| trouble |=> workspace",
      },
      {
        key_trouble.lsp.declarations.buffer,
        function()
          require("trouble").toggle("buffer_declarations")
        end,
        mode = "n",
        desc = "lsp:dec| trouble |=> buffer",
      },
      {
        key_trouble.lsp.declarations.workspace,
        function()
          require("trouble").toggle("workspace_declarations")
        end,
        mode = "n",
        desc = "lsp:dec| trouble |=> workspace",
      },
      {
        key_trouble.lsp.implementations.buffer,
        function()
          require("trouble").toggle("buffer_implementations")
        end,
        mode = "n",
        desc = "lsp:impl| trouble |=> buffer",
      },
      {
        key_trouble.lsp.implementations.workspace,
        function()
          require("trouble").toggle("workspace_implementations")
        end,
        mode = "n",
        desc = "lsp:impl| trouble |=> workspace",
      },
      {
        key_trouble.lsp.type_definitions.buffer,
        function()
          require("trouble").toggle("buffer_type_definitions")
        end,
        mode = "n",
        desc = "lsp:type| trouble |=> buffer",
      },
      {
        key_trouble.lsp.type_definitions.workspace,
        function()
          require("trouble").toggle("workspace_type_definitions")
        end,
        mode = "n",
        desc = "lsp:type| trouble |=> workspace",
      },
      {
        key_trouble.lsp.workspace,
        function()
          require("trouble").toggle("workspace_lsp")
        end,
        mode = "n",
        desc = "lsp:*| trouble |=> buffer",
      },
      {
        key_trouble.lsp.buffer,
        function()
          require("trouble").toggle("buffer_lsp")
        end,
        mode = "n",
        desc = "lsp:*| trouble |=> lsp references",
      },
      {
        key_trouble.lsp.document_symbols.buffer,
        function()
          require("trouble").toggle("buffer_document_symbols")
        end,
        mode = "n",
        desc = "lsp:sym| trouble |=> buffer",
      },
      {
        key_trouble.lsp.document_symbols.workspace,
        function()
          require("trouble").toggle("workspace_document_symbols")
        end,
        mode = "n",
        desc = "lsp:sym| trouble |=> workspace",
      },
      {
        key_trouble.telescope.buffer,
        function()
          require("trouble").toggle("buffer_telescope")
        end,
        mode = "n",
        desc = "lsp:scope| trouble |=> buffer",
      },
      {
        key_trouble.telescope.workspace,
        function()
          require("trouble").toggle("workspace_telescope")
        end,
        mode = "n",
        desc = "lsp:scope| trouble |=> workspace",
      },
      {
        key_trouble.fzf.workspace,
        function()
          require("trouble").toggle("buffer_fzf")
        end,
        mode = "n",
        desc = "lsp:fzf| trouble |=> buffer",
      },
      {
        key_trouble.fzf.workspace,
        function()
          require("trouble").toggle("workspace_fzf")
        end,
        mode = "n",
        desc = "lsp:fzf| trouble |=> workspace",
      },
    },
    event = "LspAttach",
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          -- icon used for the sign, and in search results
          icon = "󰅝 ",
          -- can be a hex color, or a named color (see below)
          color = "error",
          -- a set of other keywords that all map to this FIX keywords
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = "󱔳 ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󱕎 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󱝾 ", color = "hint", alt = { "INFO" } },
        TEST = {
          icon = "⏲ ",
          color = "test",
          alt = { "TESTING", "PASSED", "FAILED" },
        },
      },
      gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
    event = {
      "VeryLazy",
    },
    keys = {
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        mode = "n",
        desc = "todo:| comments |=> previous",
      },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        mode = "n",
        desc = "todo:| comments |=> next",
      },
    },
  },
  {
    "RaafatTurki/corn.nvim",
    config = function(_, opts)
      require("corn").setup(opts)
    end,
    opts = {
      auto_cmds = true,
      sort_method = "severity",
      scope = "line",
      highlights = {
        error = "DiagnosticFloatingError",
        warn = "DiagnosticFloatingWarn",
        info = "DiagnosticFloatingInfo",
        hint = "DiagnosticFloatingHint",
      },
      icons = {
        error = uienv.icons.diagnostic.Error,
        warn = uienv.icons.diagnostic.Warn,
        info = uienv.icons.diagnostic.Info,
        hint = uienv.icons.diagnostic.Hint,
      },
      blacklisted_modes = { "i" },
      border_style = uienv.borders.main,
      on_toggle = function(is_hidden) end,
      item_preprocess_func = function(item)
        return item
      end,
    },
    event = "LspAttach",
    keys = {
      {
        key_ui.diagnostics.corn.file,
        function()
          require("corn").scope("file")
        end,
        mode = "n",
        desc = "ui:diag| corn |=> scope to file",
      },
      {
        key_ui.diagnostics.corn.line,
        function()
          require("corn").scope("line")
        end,
        mode = "n",
        desc = "ui:diag| corn |=> scope to line",
      },
      {
        key_ui.diagnostics.corn.cycle,
        function()
          require("corn").scope_cycle()
        end,
        mode = "n",
        desc = "ui:diag| corn |=> cycle scope",
      },
      {
        key_ui.diagnostics.corn.toggle,
        function()
          require("corn").toggle()
        end,
        mode = "n",
        desc = "ui:diag| corn |=> toggle",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 2,
          source = "if_many",
          prefix = "󰛯",
        },
        severity_sort = true,
        float = {
          border = uienv.borders.alt,
          title = "󰼀 lsp::diagnostic",
          title_pos = "right",
        },
      })
      opts.log_level = vim.log.levels.WARN
    end,
  },
}
