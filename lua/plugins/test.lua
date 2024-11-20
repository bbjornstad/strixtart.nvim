local key_test = require("keys.test")

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        key_test.run.nearest,
        function()
          require("neotest").run.run()
        end,
        mode = "n",
        desc = "test:| nearest |=> run",
      },
      {
        key_test.run.file,
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        mode = "n",
        desc = "test:| file |=> run",
      },
      {
        key_test.run.dap,
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        mode = "n",
        desc = "test:| nearest |=> dap",
      },
      {
        key_test.run.stop,
        function()
          require("neotest").run.stop()
        end,
        mode = "n",
        desc = "test:| nearest |=> stop",
      },
      {
        key_test.run.attach,
        function()
          require("neotest").run.attach()
        end,
        mode = "n",
        desc = "test:| nearest |=> attach",
      },
    },
  },
  {
    "folke/lazydev.nvim",
    opts = function(_, opts)
      opts.library = opts.library or {}
      opts.library = table.insert(opts.library, "neotest")
    end,
  },
}
