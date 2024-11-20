local env = require("env.ui")
local key_docs = require("keys.docs")
local key_devdocs = key_docs.devdocs
local key_neogen = key_docs.neogen
local key_pandoc = key_docs.auto_pandoc
local key_treedocs = key_docs.treedocs

return {
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      float_win = {
        relative = "editor",
        height = 32,
        width = 100,
        border = env.borders.main,
      },
      previewer_cmd = "glow",
    },
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsOpenCurrent",
      "DevdocsOpenCurrentFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },
    keys = {
      {
        key_devdocs.fetch,
        "<CMD>DevdocsFetch<CR>",
        mode = "n",
        desc = "docs:| dev |=> fetch",
      },
      {
        key_devdocs.install,
        "<CMD>DevdocsInstall<CR>",
        mode = "n",
        desc = "docs:| dev |=> install",
      },
      {
        key_devdocs.uninstall,
        "<CMD>DevdocsUninstall<CR>",
        mode = "n",
        desc = "docs:| dev |=> uninstall",
      },
      {
        key_devdocs.open_float,
        "<CMD>DevdocsOpenFloat<CR>",
        mode = "n",
        desc = "docs:| dev |=> open (float)",
      },
      {
        key_devdocs.buffer_float,
        "<CMD>DevdocsOpenCurrentFloat<CR>",
        mode = "n",
        desc = "docs:| dev |=> buffer (float)",
      },
      {
        key_devdocs.open,
        "<CMD>DevdocsOpen<CR>",
        mode = "n",
        desc = "docs:| dev |=> open",
      },
      {
        key_devdocs.buffer,
        "<CMD>DevdocsOpenCurrent<CR>",
        mode = "n",
        desc = "docs:| dev |=> buffer",
      },
    },
  },
  {
    "jghauser/auto-pandoc.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
    keys = {
      {
        key_pandoc.run,
        function()
          require("auto-pandoc").run_pandoc()
        end,
        mode = "n",
        desc = "docs:| convert |=> use pandoc",
        buffer = 0,
        remap = false,
        silent = true,
      },
    },
  },
  {
    "danymat/neogen",
    cmd = { "Neogen" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      languages = {},
      snippet_engine = "nvim",
      placeholders_text = {
        ['description'] = "-< [TODO(docs)]::[description] >-",
        ['tparam'] = "-< [TODO(docs)]::[tparam] >-",
        ['parameter'] = "-< [TODO(docs)]::[param] >-",
        ['return'] = "-< [TODO(docs)]::[return] >-",
        ['class'] = "-< [TODO(docs)]::[class] >-",
        ['throw'] = "-< [TODO(docs)]::[throw] >-",
        ['varargs'] = "-< [TODO(docs)]::[varargs] >-",
        ['type'] = "-< [TODO(docs)]::[type] >-",
        ['attribute'] = "-< [TODO(docs)]::[attribute] >-",
        ['args'] = "-< [TODO(docs)]::[args] >-",
        ['kwargs'] = "-< [TODO(docs)]::[kwargs] >-",
      },
      placeholders_hl = "DiagnosticHint",
    },
    keys = {
      {
        key_neogen.generate,
        function()
          return require("neogen").generate({ type = "any" })
        end,
        mode = "n",
        desc = "docs:| gen |=> generic docstring",
      },
      {
        key_neogen.class,
        function()
          return require("neogen").generate({ type = "class" })
        end,
        mode = "n",
        desc = "docs:| gen |=> class/obj docstring",
      },
      {
        key_neogen.type,
        function()
          return require("neogen").generate({ type = "type" })
        end,
        mode = "n",
        desc = "docs:| gen |=> type docstring",
      },
      {
        key_neogen.fn,
        function()
          return require("neogen").generate({ type = "func" })
        end,
        mode = "n",
        desc = "docs:| gen |=> function docstring",
      },
    },
  },
  {
    "milisims/nvim-luaref",
    event = "VeryLazy",
    opts = {},
    config = function() end,
  },
  {
    "aspeddro/pandoc.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "WERDXZ/nvim-dox",
    opts = {},
    config = function(_, opts) end,
    cmd = "Dox",
  },
}
