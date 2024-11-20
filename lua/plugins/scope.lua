local uienv = require("env.ui")
local key_scope = require("keys.scope")
local key_shortcut = require('keys.shortcut')

local function funblt(builtin_name, builtin_override, opts)
  opts = opts or {}
  builtin_override = builtin_override or "telescope.builtin"
  return function()
    require(builtin_override)[builtin_name](opts)
  end
end

return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ['Z'] = { name = "::| telescope |::" },
      },
    },
  },
  {
    "BurntSushi/ripgrep",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    event = { "FileType TelescopePrompt" },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_stragegy = "flex",
        layout_config = {
          horizontal = {
            size = {
              width = "85%",
              height = "60%",
            },
          },
          vertical = {
            size = {
              width = "85%",
              height = "85%",
            },
          },
        },
        mappings = {
          i = {
            ["<C-w>"] = "which_key",
            ['<C-c>'] = "close",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-q>"] = function(prompt_bufnr)
              require("telescope.actions").smart_send_to_qflist(prompt_bufnr)
              require("telescope.actions").open_qflist(prompt_bufnr)
            end,
          },
          n = {
            ["q"] = "close",
            ["qq"] = "close",
            ['<C-c>'] = "close",
            ["gh"] = "which_key",
            ["<c-j>"] = "move_selection_next",
            ["<c-k>"] = "move_selection_previous",
            ["<C-q>"] = function(prompt_bufnr)
              require("telescope.actions").smart_send_to_qflist(prompt_bufnr)
              require("telescope.actions").open_qflist(prompt_bufnr)
            end,
          },
        },
        winblend = 14,
        prompt_prefix = " ",
        selection_caret = " ",
        initial_mode = "insert",
        dynamic_preview_title = true,
        prompt_title = "scope::searching...",
        scroll_strategy = "cycle",
        border = true,
        borderchars = uienv.borders.telescope,
        path_display = { "smart" },
        wrap_results = true,
      },
      -- pickers = pickspec,
    },
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
    },
    keys = {
      {
        key_scope.files.find,
        funblt("find_files"),
        mode = "n",
        desc = "scope:| pick |=> find files",
      },
      {
        key_scope.pickers.builtin,
        funblt("builtin"),
        mode = "n",
        desc = "scope:| pick |=> builtin",
      },
      {
        key_scope.treesitter,
        funblt("treesitter"),
        mode = "n",
        desc = "scope:| pick |=> treesitter nodes",
      },
      {
        key_scope.pickers.extensions,
        funblt("pickers"),
        mode = "n",
        desc = "scope:| pick |=> pickers",
      },
      {
        key_shortcut.buffers.scope,
        function()
          require("telescope.builtin").buffers()
        end,
        mode = "n",
        desc = "scope:| pick |=> buffers",
      },
    },
  },

  {
    "LinArcX/telescope-changes.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("changes")
    end,
    keys = {
      {
        key_scope.changes,
        function()
          require("telescope").extensions.changes.changes()
        end,
        mode = "n",
        desc = "scope:| ext |=> changes",
      },
    },
  },

  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("dap")
    end,
    keys = {
      {
        key_scope.dap.commands,
        function()
          require("telescope").extensions.dap.commands()
        end,
        mode = "n",
        desc = "scope:| ext:dap |=> commands",
      },
      {
        key_scope.dap.configurations,
        function()
          require("telescope").extensions.dap.configurations()
        end,
        mode = "n",
        desc = "scope:| ext:dap |=> configurations",
      },
      {
        key_scope.dap.list_breakpoints,
        function()
          require("telescope").extensions.dap.list_breakpoints()
        end,
        mode = "n",
        desc = "scope:| ext:dap |=> list breakpoints",
      },
      {
        key_scope.dap.variables,
        function()
          require("telescope").extensions.dap.variables()
        end,
        mode = "n",
        desc = "scope:| ext:dap |=> variables",
      },
      {
        key_scope.dap.frames,
        function()
          require("telescope").extensions.dap.frames()
        end,
        mode = "n",
        desc = "scope:| ext:dap |=> frames",
      },
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("undo")
    end,
    keys = {
      {
        key_scope.undo,
        function()
          require("telescope").extensions.undo.undo()
        end,
        mode = "n",
        desc = "scope:| ext |=> undo",
      },
    },
  },
  {
    "nat-418/telescope-color-names.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("color_names")
    end,
    keys = {
      {
        key_scope.color_names,
        function()
          require("telescope").extensions.color_names.color_names()
        end,
        mode = "n",
        desc = "scope:| ext |=> color names",
      },
    },
  },
  {
    "barrett-ruth/telescope-http.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("http")
    end,
    keys = {
      {
        key_scope.http,
        function()
          require("telescope").extensions.http.list()
        end,
        mode = "n",
        desc = "scope:| ext |=> http status code",
      },
    },
  },
  {
    "nvim-lua/popup.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
  },
  {
    "IrisRainbow7/telescope-lsp-server-capabilities.nvim",
    config = function(_, opts)
      require("telescope").load_extension("lsp_server_capabilities")
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {},
    keys = {
      {
        key_scope.lsp_capabilities,
        function()
          require("telescope").extensions.lsp_server_capabilities.lsp_server_capabilities()
        end,
        mode = "n",
        desc = "scope:| lsp |=> capabilities",
      },
    },
  },
}
