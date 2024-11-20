---@diagnostic disable: param-type-mismatch
local env = require("env.ui")
local key_snippet = require("keys.tool").snippet

return {
  {
    "garymjr/nvim-snippets",
    opts = {
      create_autocmd = false,
      create_cmp_source = true,
      friendly_snippets = true,
      ignored_filetypes = {},
      extended_filetypes = {},
      global_snippets = { "all" },
      search_paths = { vim.fs.joinpath(vim.fn.stdpath("config"), "/snippets") },
    },
    event = "VeryLazy",
    dependencies = {
      { "rafamadriz/friendly-snippets", optional = true },
      { "nvim-cmp", optional = true },
    },
  },
  { "rafamadriz/friendly-snippets", config = false, event = "VeryLazy" },
  {
    "chrisgrieser/nvim-scissors",
    opts = {
      snippetDir = vim.fs.joinpath(vim.fn.stdpath("config"), "/snippets"),
      editSnippetPopup = {
        border = env.borders.main,
        width = 0.64,
        height = 0.48,
        keymaps = {
          cancel = "q",
          saveChanges = "<CR>",
          goBackToSearch = "<BS>",
          deleteSnippet = "<C-BS>",
          duplicateSnippet = "<C-d>",
          openInFile = "<C-e>",
          insertNextPlaceholder = "<C-n>",
        },
      },
      jsonFormatter = "yq",
    },
    event = "VeryLazy",
    keys = {
      {
        key_snippet.add,
        function()
          require("scissors").addNewSnippet()
        end,
        mode = "n",
        desc = "snip=> add new",
      },
      {
        key_snippet.edit,
        function()
          require("scissors").editSnippet()
        end,
        mode = "n",
        desc = "snip=> edit",
      },
    },
  },
}
