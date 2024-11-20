local hoot = require("util.hoot")

local TOOL_TOPOLOGY = {
  server = {
    mason = {
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
          ensure_installed = hoot.nor(
            hoot.insert({
              from = "ensure_installed",
            }),
            hoot.insert({ from = "name" })
          ),
        },
      },
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          handlers = hoot.insert({
            from = "handler",
          }),
        },
      },
    },
    nonmason = {
      {
        "neovim/nvim-lspconfig",
        opts = {
          servers = hoot.insert({ from = "handler", ix = "name" }),
        },
      },
    },
  },
  linter = {
    mason = {
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
          ensure_installed = hoot.nor(
            hoot.insert({
              from = "ensure_installed",
            }),
            hoot.insert({ from = "name" })
          ),
        },
      },
    },
    _ = {
      {
        "mfussenegger/nvim-lint",
        opts = {
          linters_by_ft = hoot.insert({
            from = "name",
            ix = "language.filetypes",
          }),
        },
      },
      {
        "mfussenegger/nvim-lint",
        opts = {
          linters = hoot.send({ from = "defn", ix = "name" }),
        },
      },
    },
  },
  formatter = {
    mason = {
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
          ensure_installed = hoot.nor(
            hoot.insert({ from = "ensure_installed" }),
            hoot.insert({ from = "name" })
          ),
        },
      },
    },
    _ = {
      {
        "stevearc/conform.nvim",
        opts = {
          formatters_by_ft = hoot.insert({
            from = "name",
            ix = "language.filetypes",
          }),
        },
      },
      {
        "stevearc/conform.nvim",
        opts = {
          formatters = hoot.send({
            from = "defn",
            ix = "name",
          }),
        },
      },
    },
  },
  debugger = {
    mason = {
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
          ensure_installed = hoot.insert({ from = "ensure_installed" }),
        },
      },
      {
        "jay-babu/mason-nvim-dap",
        opts = {
          handlers = hoot.insert({ from = "handler" }),
        },
      },
    },
    nonmason = {
      {
        "jay-babu/nvim-dap",
        opts = {
          configurations = hoot.insert({ from = "configuration" }),
          adapters = hoot.insert({ from = "adapter" }),
        },
      },
    },
  },
}

return TOOL_TOPOLOGY
