local uienv = require("env.ui")

local key_ui = require("keys.ui")

return {
  {
    "folke/snacks.nvim",
    priority = 998,
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 2400,
        padding = true,
        width = { min = 32, max = 0.4 },
        height = { min = 2, max = 0.4 },
        margin = { top = 4, right = 4, bottom = 4 },
        icons = uienv.icons.state,
        style = "fancy",
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      styles = {
        notification = {
          border = uienv.borders.main,
          ft = "markdown",
          wo = {
            wrap = true,
            winblend = 32,
            conceallevel = 2,
          }, -- Wrap notifications
          bo = { filetype = "snacks_notif" },
          history = {
            border = uienv.borders.alt,
            title = "  :: notifications ",
            title_pos = "right",
            ft = "markdown",
            bo = { filetype = "snacks_notif_history" },
            wo = { winhighlight = "Normal:SnacksNotifierHistory", wrap = true },
            keys = { q = "close", ["<C-c>"] = "close" },
            minimal = false,
            width = 0.42,
            height = 0.42,
          },
        },
      },
    },
    keys = {
      {
        "<leader>un",
        function()
          require("snacks").notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<leader>gg",
        function()
          require("snacks").lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>gb",
        function()
          require("snacks").git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gB",
        function()
          require("snacks").gitbrowse()
        end,
        desc = "Git Browse",
      },
      {
        "<leader>gf",
        function()
          require("snacks").lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
      {
        "<leader>gl",
        function()
          require("snacks").lazygit.log()
        end,
        desc = "Lazygit Log (cwd)",
      },
      {
        "<leader>cR",
        function()
          require("snacks").rename()
        end,
        desc = "Rename File",
      },
      {
        "<c-/>",
        function()
          require("snacks").terminal()
        end,
        desc = "Toggle Terminal",
      },
      {
        "<c-_>",
        function()
          require("snacks").terminal()
        end,
        desc = "which_key_ignore",
      },
      {
        "[[",
        function()
          require("snacks").words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          require("snacks").words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
      },
      {
        "<leader>NN",
        desc = "Neovim News",
        function()
          require("snacks").win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = true,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          local snacks = require("snacks")
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            snacks.debug.inspect(...)
          end
          _G.bt = function()
            snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks') for `:=` command

          -- Create some toggle mappings
          snacks.toggle
            .option("spell", { name = "Spelling" })
            :map(key_ui.spelling)
          snacks.toggle.option("wrap", { name = "Wrap" }):map(key_ui.wrap)
          snacks.toggle
            .option("relativenumber", { name = "Relative Number" })
            :map(key_ui.numbers.relative)
          snacks.toggle.diagnostics():map(key_ui.diagnostics.toggle)
          snacks.toggle.line_number():map(key_ui.numbers.line)
          snacks.toggle
            .option("conceallevel", {
              off = 0,
              on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
            })
            :map(key_ui.conceal)
          snacks.toggle.treesitter():map(key_ui.treesitter)
          snacks.toggle
            .option(
              "background",
              { off = "light", on = "dark", name = "Dark Background" }
            )
            :map(key_ui.background)
          snacks.toggle.inlay_hints():map(key_ui.inlay_hints)
          snacks.toggle
            .option("winfixbuf", { name = "Buffer Pin", off = false, on = true })
            :map(key_ui.pinbuf)
        end,
      })
    end,
  },
  {
    "jrop/u.nvim",
    lazy = true,
  },
}
