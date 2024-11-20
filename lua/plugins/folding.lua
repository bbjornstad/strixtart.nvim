local env = require("env.ui")

return { -- add folding range to capabilities
  {
    "milisims/foldhue.nvim",
    event = "BufWinEnter",
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "VonHeikemen/lsp-zero.nvim",
    },
    config = function(_, opts)
      require("ufo").setup(opts)
      local zero = require("lsp-zero")
      zero.set_server_config({
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
      })
    end,
    event = "BufWinEnter",
    opts = {
      -- fold_virt_text_handler = handler,
      preview = {
        win_config = {
          border = env.borders.main,
        },
      },
    },
    init = function()
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldcolumn = "0"
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    end,
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        mode = "n",
        desc = "ufo:| * |=> open",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        mode = "n",
        desc = "ufo:| * |=> close",
      },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        mode = "n",
        desc = "ufo:| $ => open",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        mode = "n",
        desc = "ufo:| $ |=> close this ultrafolded",
      },
      {
        "zI",
        function()
          require("ufo").inspect()
        end,
        mode = "n",
        desc = "ufo:buf| inspect => current",
      },
      {
        "zp",
        function()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        mode = "n",
        desc = "ufo:| . => peek",
      },
    },
  },
  {
    "bbjornstad/pretty-fold.nvim",
    dependencies = { "kevinhwang91/nvim-ufo" },
    event = "BufWinEnter",
    opts = {
      sections = {
        left = {
          "content",
        },
        right = {
          "  ",
          "number_of_folded_lines",
          ": ",
          "percentage",
          "  ",
          function(config)
            local win = vim.api.nvim_get_current_win()
            local wid = vim.api.nvim_win_get_width(win)
            return config.fill_char:rep(math.floor(wid / 16))
          end,
        },
      },
      fill_char = "─╼",

      remove_fold_markers = false,

      -- Keep the indentation of the content of the fold string.
      keep_indentation = true,

      -- Possible values:
      -- "delete" : Delete all comment signs from the fold string.
      -- "spaces" : Replace all comment signs with equal number of spaces.
      -- false    : Do nothing with comment signs.
      process_comment_signs = false,

      -- Comment signs additional to the value of `&commentstring` option.
      comment_signs = {},

      -- List of patterns that will be removed from content foldtext section.
      stop_words = {},

      add_close_pattern = true, -- true, 'last_line' or false

      matchup_patterns = {
        { "^%s*do$", "end" },
        { "^%s*if", "end" },
        { "^%s*for", "end" },
        { "function%s*%(", "end" },
        { "{", "}" },
        { "%(", ")" }, -- % to escape lua pattern char
        { "%[", "]" }, -- % to escape lua pattern char
      },

      ft_ignore = { "neorg" },
    },
  },
  {
    "chrisgrieser/nvim-origami",
    opts = {
      keepFoldsAcrossSessions = false,
      pauseFoldsOnSearch = true,
      setupFoldKeymaps = true,
    },
    event = "BufWinEnter",
  },
  {
    "yaocccc/nvim-foldsign",
    event = "BufWinEnter",
    opts = {
      offset = -4,
      foldsigns = {
        open = "⌐",
        close = "⌙",
        seps = { "┃", "│" },
      },
    },
  },
}
