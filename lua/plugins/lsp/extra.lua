return {
  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    config = false,
  },
  {
    "nvim-lua/lsp-status.nvim",
    opts = {
      show_filename = false,
      indicator_separator = ":",
      diagnostics = false,
      status_symbol = "󱁦",
    },
    event = "LspAttach",
    config = function(_, opts)
      require("lsp-status").config(opts)
    end,
  },
  {
    "jubnzv/virtual-types.nvim",
    config = function(_, opts) end,
    opts = { enabled = true },
    event = "LspAttach",
  },
}
