local key_newts = require("keys.newts")
local key_scope = require("keys.scope")
local uienv = require("env.ui")

return {
  {
    "folke/noice.nvim",
    enabled = false,
    event = "UIEnter",
    opts = {
      debug = true,
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = {},
        format = {
          -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
          -- view: (default is cmdline view)
          -- opts: any options passed to the view
          -- icon_hl_group: optional hl_group for the icon
          -- title: set to anything or empty string to hide
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = {
            kind = "search",
            pattern = "^/",
            icon = " ",
            lang = "regex",
          },
          search_up = {
            kind = "search",
            pattern = "^%?",
            icon = " ",
            lang = "regex",
          },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = {
            pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
            icon = "",
            lang = "lua",
          },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
          input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
          -- lua = false, -- to disable a format, set to `false`
        },
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      popupmenu = {
        enabled = true, -- enables the Noice popupmenu UI
        ---@type 'nui'|'cmp'
        backend = "nui", -- backend to use to show regular cmdline completions
        ---@type NoicePopupmenuItemKind|false
        -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
        kind_icons = uienv.icons.kinds, -- set to `false` to disable icons
      },
      -- default options for require('noice').redirect
      -- see the section on Command Redirection
      ---@type NoiceRouteConfig
      redirect = {
        view = "popup",
        filter = { event = "msg_show" },
      },
      lsp = {
        progress = {
          enabled = true,
          -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
          -- See the section on formatting for more details on how to customize.
          --- @type NoiceFormat|string
          format = "lsp_progress",
          --- @type NoiceFormat|string
          format_done = "lsp_progress_done",
          throttle = 1000 / 30, -- frequency to update lsp progress message
          view = "mini",
        },
        override = {
          -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          -- override the lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = true,
          -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = false, -- set to true to not show a message if hover is not available
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 50ms
          },
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
        },
        message = {
          -- Messages shown by lsp servers
          enabled = true,
          view = "notify",
          opts = {},
        },
        -- defaults for hover and signature help
        documentation = {
          view = "hover",
          ---@type NoiceViewOptions
          opts = {
            lang = "markdown",
            replace = true,
            render = "plain",
            format = { "{message}" },
            win_options = { concealcursor = "n", conceallevel = 3 },
          },
        },
      },
      markdown = {
        hover = {
          ["|(%S-)|"] = vim.cmd.help, -- vim help links
          ["%[.-%]%((%S-)%)"] = function(uri)
            require("noice.util").open(uri)
          end,
        },
        highlights = {
          ["|%S-|"] = "@text.reference",
          ["@%S+"] = "@parameter",
          ["^%s*(Parameters:)"] = "@text.title",
          ["^%s*(Return:)"] = "@text.title",
          ["^%s*(See also:)"] = "@text.title",
          ["{%S-}"] = "@parameter",
        },
      },
      health = {
        checker = true, -- Disable if you don't want health checks to run
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,
        lsp_doc_border = true,
        -- cmdline_output_to_split = true,
      },
      views = {
        popup = {
          close = {
            events = { "BufLeave" },
            keys = { "q", "<C-c>" },
          },
          border = {
            style = uienv.borders.main,
            padding = uienv.padding.noice.main,
          },
          size = {
            width = "60%",
            height = "32%",
          },
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
            winbar = "",
            foldenable = false,
          },
        },
        cmdline = {
          position = { row = 16, col = "50%" },
          size = { height = "auto", width = "100%" },
          border = {
            padding = uienv.padding.noice.main,
            style = uienv.borders.main,
          },
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
              IncSearch = "",
              CurSearch = "",
              Search = "",
            },
          },
        },
        mini = {
          timeout = 1618,
          size = {
            width = "auto",
            height = "auto",
          },
          border = {
            style = "none",
          },
          zindex = 60,
          win_options = {
            winblend = 42,
          },
        },
        cmdline_popup = {
          backend = "popup",
          fallback = "cmdline",
          position = { row = "24%", col = "50%" },
          size = {
            width = "auto",
            height = "auto",
            min_width = 72,
          },
          -- put it on top of everything else that could exist below (we picked
          -- 1200 because it was larger than the largest present zindex
          -- definition for any other component)
          border = {
            style = uienv.borders.main,
            padding = uienv.padding.noice.main,
          },
          win_options = {
            winhighlight = {
              -- Normal = "Normal",
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
              FloatTitle = "PMenu",
            },
            winbar = "",
            foldenable = false,
            cursorline = false,
          },
        },
        cmdline_input = {
          view = "cmdline_popup",
          border = {
            style = uienv.borders.main,
            padding = uienv.padding.noice.main,
          },
        },
        cmdline_output = {
          format = "details",
          view = "split",
        },
        popupmenu = {
          size = { width = "auto", height = "auto", max_height = 24 },
          -- once again, put it on top of everything else that could exist below.
          -- 1200 rationale still holds here too.
          zindex = 65,
          border = {
            style = uienv.borders.main,
            padding = uienv.padding.noice.main,
          },
          win_options = {
            winhighlight = {
              -- Normal = "Normal",
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        hover = {
          view = "popup",
          relative = "cursor",
          enter = false,
          anchor = "auto",
          size = {
            width = "auto",
            height = "auto",
            max_height = 36,
            max_width = 120,
          },
          border = {
            style = uienv.borders.alt,
            padding = uienv.padding.noice.main,
          },
        },
        split = {
          size = 24,
          enter = true,
          win_options = {
            wrap = true,
          },
          close = {
            keys = { "q", "<C-c>" },
          },
        },
        vsplit = {
          view = "split",
          position = "right",
        },
        confirm = {
          backend = "popup",
          relative = "editor",
          position = {
            row = "24%",
            col = "50%",
          },
          size = {
            width = "auto",
            height = "auto",
            max_height = 24,
          },
          border = {
            style = uienv.borders.alt,
            padding = uienv.padding.noice.main,
            text = {
              top = " ::confirm:: ",
            },
          },
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        notify = {
          backend = { "snacks", "notify" },
          format = "notify",
          merge = true,
        },
        messages = {
          view = "vsplit",
          enter = true,
        },
        cmdline_popupmenu = {
          view = "popupmenu",
        },
      },
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Processing file symbols...",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "msg_show",
            kind = "progress",
            find = "checking document",
          },
          opts = { skip = true },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Diagnosing",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Processing full semantic tokens",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Searching in files...",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Processing reference...",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "notify",
          filter = {
            event = "msg_show",
            kind = "echo",
            find = "[gentags]",
          },
          opts = {
            skip = true,
          },
        },
      },
      throttle = 1000 / 25,
    },
    keys = {
      {
        "<S-CR>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "noice:| cmdline |=> redirect",
      },
      {
        "<C-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-d>"
          end
        end,
        mode = { "n", "i", "s" },
        silent = true,
        expr = true,
        desc = "lsp:| doc |=> down",
      },
      {
        "<C-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-u>"
          end
        end,
        mode = { "n", "i", "s" },
        silent = true,
        expr = true,
        desc = "lsp:| doc |=> up",
      },
      {
        key_newts.messages,
        "<CMD>messages<CR>",
        mode = "n",
        desc = "newts:| vim |=> messages",
      },
      {
        key_newts.errors,
        function()
          require("noice").cmd("errors")
        end,
        mode = "n",
        desc = "newts:| errors |=> open",
      },
      {
        key_newts.notifications,
        function()
          require("noice").cmd("telescope")
        end,
        mode = "n",
        desc = "newts:| history |=> telescope",
      },
      {
        key_newts.history,
        function()
          require("noice").cmd("history")
        end,
        mode = "n",
        desc = "newts:| history |=> messages",
      },
      {
        key_newts.stats,
        function()
          require("noice").cmd("stats")
        end,
        mode = "n",
        desc = "newts:| debug |=> show stats",
      },
      {
        key_newts.last,
        function()
          require("noice").cmd("last")
        end,
        mode = "n",
        desc = "newts:| history |=> last message",
      },
      {
        key_scope.notice,
        function()
          require("noice").cmd("telescope")
        end,
        mode = "n",
        desc = "scope:| newts |=> search",
      },
      {
        key_newts.dismiss,
        function()
          require("noice").cmd("dismiss")
        end,
        mode = "n",
        desc = "newts:| notice |=> clear",
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      top_down = true,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, {
          border = uienv.borders.main,
          zindex = 300,
        })
        vim.api.nvim_set_option_value("wrap", true, { win = win })
      end,
      background_colour = "Pmenu",
      stages = "static",
    },
    keys = {
      {
        "<leader>nC",
        function()
          require("notify").dismiss({ silent = true, pending = false })
        end,
        mode = "n",
        desc = "ui:| notice |=> clear",
      },
      {
        "<leader>nN",
        function()
          require("notify").history()
        end,
        mode = "n",
        desc = "newts:| history |=> notifications",
      },
    },
  },
}
