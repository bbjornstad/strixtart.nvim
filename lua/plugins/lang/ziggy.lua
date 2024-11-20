local lang = require("util.lang")

local ziggy = lang.language("ziggy", { "ziggy" }, { mason = true })
local ziggy_schema = lang.language(
  "ziggy_schema",
  { "ziggy_schema" },
  { mason = true }
)

return {
  ziggy
    :server("ziggy")
    :formatter("ziggy", {
      formatters = function(opts)
        opts.ziggy = {
          inherit = false,
          command = "ziggy",
          stdin = true,
          args = { "fmt", "--stdin" },
        }
      end,
      formatters_by_ft = function(opts)
        opts.ziggy = { "ziggy" }
      end,
    })
    :tolazy(),
  ziggy_schema
    :server("ziggy_schema")
    :formatter("ziggy_schema", {
      formatters = function(opts)
        opts.ziggy_schema = {
          inherit = false,
          command = "ziggy",
          stdin = true,
          args = { "fmt", "--stdin-schema" },
        }
      end,
      formatters_by_ft = function(opts)
        opts.ziggy_schema = { "ziggy_schema" }
      end,
    })
    :tolazy(),
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local parser_configs =
        require("nvim-treesitter.parsers").get_parser_configs()
      parser_configs.ziggy = {
        install_info = {
          url = "https://github.com/kristoff-it/ziggy",
          includes = { "tree-sitter-ziggy/src" },
          files = { "tree-sitter-ziggy/src/parser.c" },
        },
        filetype = "ziggy",
      }
      parser_configs.ziggy_schema = {
        install_info = {
          url = "https://github.com/kristoff-it/ziggy", -- local path or git repo
          files = { "tree-sitter-ziggy-schema/src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
        },
        filetype = "ziggy-schema",
      }
    end,
  },
}
