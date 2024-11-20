local lang = require("util.lang")

local key_lsp = require("keys.lsp")

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        text = { "codespell", "vale" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters = lint.linters or {}
      lint.linters =
        vim.tbl_deep_extend("force", lint.linters, opts.linters or {})
      lint.linters_by_ft = lint.linters_by_ft or {}
      lint.linters_by_ft = vim.tbl_deep_extend(
        "force",
        lint.linters_by_ft or {},
        opts.linters_by_ft or {}
      )

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        callback = function(ev)
          require("lint").try_lint()
        end,
        desc = "󰉂 lsp:| lint |=> Buf{Enter,WritePost}",
      })
    end,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        key_lsp.lint.lint,
        function()
          require("lint").try_lint()
        end,
        mode = "n",
        desc = "lsp:| lint |=> try",
      },
    },
  },
  {
    "rshkarin/mason-nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    opts = {
      automatic_installation = true,
    },
  },
  {
    "chrisgrieser/nvim-rulebook",
    event = "LspAttach",
    keys = {
      {
        key_lsp.lint.ignore,
        function()
          require("rulebook").ignoreRule()
        end,
        mode = "n",
        desc = "lsp:| lint |=> ignore rule",
      },
      {
        key_lsp.lint.lookup,
        function()
          require("rulebook").lookupRule()
        end,
        mode = "n",
        desc = "lsp:| lint |=> lookup rule",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        virtual_text = {
          suffix = function(diag)
            return require("rulebook").hasDocs(diag) and " 󱙽" or ""
          end,
        },
      })
    end,
  },
}
