local key_lsp = require("keys.lsp")
local uienv = require("env.ui")

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      max_concurrent_installers = 10,
      ui = {
        border = uienv.borders.alt,
        icons = uienv.icons.mason.package,
      },
    },
    keys = {
      {
        key_lsp.code.mason,
        "<CMD>Mason<CR>",
        mode = "n",
        desc = "lsp:| mason |=> info panel",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {},
      automatic_installation = true,
      handlers = {
        function(srv)
          require("lspconfig")[srv].setup({})
        end,
      },
    },
    opts_extend = { "ensure_installed" },
    config = function(_, opts) end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {},
      auto_update = true,
      run_on_start = true,
      start_delay = 0,
      debounce_hours = 1,
      integrations = {
        ["mason-lspconfig"] = true,
        ["mason-null-ls"] = true,
        ["mason-nvim-dap"] = true,
      },
    },
    opts_extend = { "ensure_installed" },
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    opts = {
      ensure_intalled = {},
      automatic_installation = true,
      quiet_mode = false,
    },
    opts_extend = { "ensure_installed" },
  },
  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
    opts = {
      ignore_install = {},
    },
    opts_extend = { "ignore_install" },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {},
      automatic_installation = true,
      handlers = {
        function(config)
          if vim.is_callable(config) then
            config = config()
          end
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
    opts_extend = { "ensure_installed" },
  },
}
