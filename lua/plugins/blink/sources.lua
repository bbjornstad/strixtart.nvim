return {
  { "saghen/blink.compat" },
  {
    "saghen/blink.cmp",
    dependencies = {
      { "saghen/blink.compat" },
      { "rcarriga/cmp-dap" },
      { "bydlw98/cmp-env" },
      -- { "SergioRibera/cmp-dotenv" },
      -- { "octaltree/cmp-look" },
      {
        "uga-rosa/cmp-dictionary",
        ft = {
          "markdown",
          "rmd",
          "quarto",
          "org",
          "norg",
          "latex",
          "tex",
          "bibtex",
        },
      },
      { "hrsh7th/cmp-omni" },
      -- Next Up: Filetype Specific
      -- git
      {
        "petertriho/cmp-git",
        ft = {
          "gitrebase",
          "gitcommit",
          "gitattributes",
          "gitconfig",
          "gitignore",
        },
      },
      -- -- shell items
      { "tamago324/cmp-zsh", ft = "zsh" },
      { "mtoohey31/cmp-fish", ft = { "fish" } },
      -- -- other random stuff
      { "pontusk/cmp-sass-variables", ft = { "sass", "scss" } },
      { "KadoBOT/cmp-plugins", ft = { "lua" } },
      {
        "kdheepak/cmp-latex-symbols",
        ft = {
          "markdown",
          "rmd",
          "quarto",
          "org",
          "norg",
          "latex",
          "tex",
          "bibtex",
        },
      },
      {
        "micangl/cmp-vimtex",
        optional = true,
        ft = { "latex", "tex", "bibtex" },
      },
      -- AI tooling
      { "tzachar/cmp-ai", optional = true },
      -- Lastly: Extra Things
      {
        "nat-418/cmp-color-names.nvim",
        config = true,
        ft = { "html", "css", "js", "md", "org", "norg", "scss", "sass" },
      },
      { "amarakon/nvim-cmp-fonts" },
      {
        "jcha0713/cmp-tw2css",
        ft = { "sass", "scss", "css" },
      },
      { "netmute/blink-cmp-ctags" },
      { "niuiic/blink-cmp-rg.nvim" },
    },
    opts = {
      sources = {
        completion = {
          enabled_providers = {
            "lsp",
            "path",
            "snippets",
            "buffer",
            -- "lazydev",
            "dap",
            -- "look",
            "omni",
            "ripgrep",
            "env",
            -- "dotenv",
            "ctags",
            "fonts",
          },
        },
        providers = {
          -- lsp = {
          --   fallback_for = { "lazydev" },
          -- },
          -- lazydev = {
          --   name = "lazydev",
          --   module = "lazydev.integrations.blink",
          -- },
          dap = {
            name = "dap",
            module = "blink.compat.source",
          },
          look = {
            name = "look",
            module = "blink.compat.source",
            opts = {
              convert_case = true,
              loud = true,
            },
          },
          omni = {
            name = "omni",
            module = "blink.compat.source",
            opts = {
              disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
            },
          },
          env = {
            name = "env",
            module = "blink.compat.source",
          },
          dotenv = {
            name = "dotenv",
            module = "blink.compat.source",
            opts = {
              path = ".",
              load_shell = true,
              item_kind = require("cmp").lsp.CompletionItemKind.Variable,
              eval_on_confirm = false,
              show_documentation = true,
              show_content_on_docs = true,
              documentation_kind = "markdown",
              dotenv_environment = ".*",
              file_priority = function(a, b)
                return a.upper() < b.upper()
              end,
            },
          },
          fonts = {
            name = "fonts",
            module = "blink.compat.source",
            opts = {
              space_filter = "-",
            },
          },
          ctags = {
            name = "Ctags",
            module = "blink-cmp-ctags",
            fallback_for = { "lsp" },
            opts = {
              -- List of tag files
              tag_files = vim.fn.tagfiles(),

              -- Turn tagfile caching on or off
              cache = true,

              -- Tag kinds to include
              include_kinds = { "f", "v", "c", "m", "t" },

              -- Maximum number of completion items to return
              max_items = 500,
            },
          },
          ripgrep = {
            module = "blink-cmp-rg",
            name = "Ripgrep",
            -- options below are optional, these are the default values
            ---@type blink-cmp-rg.Options
            opts = {
              -- blink.cmp get prefix in a different way,
              -- thus use `prefix_min_len` instead of `min_keyword_length`
              prefix_min_len = 3,
              get_command = function(context, prefix)
                return {
                  "rg",
                  "--no-config",
                  "--json",
                  "--word-regexp",
                  "--ignore-case",
                  "--",
                  prefix .. "[\\w_-]+",
                  vim.fs.root(0, ".git") or vim.fn.getcwd(),
                }
              end,
              get_prefix = function(context)
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local line = vim.api.nvim_get_current_line()
                local prefix = line:sub(1, col):match("[%w_-]+$") or ""
                return prefix
              end,
            },
          },
          git = {
            name = "git",
            module = "blink.compat.source",
            opts = {},
          },
          dictionary = {
            name = "dictionary",
            module = "blink.compat.source",
          },
          zsh = {
            name = "zsh",
            module = "blink.compat.source",
          },
          fish = {
            name = "fish",
            module = "blink.compat.source",
          },
          sass = {
            name = "sass-variables",
            module = "blink.compat.source",
          },
          tailwind = {
            name = "cmp-tw2css",
            module = "blink.compat.source",
          },
          crates = {
            name = "crates",
            module = "blink.compat.source",
          },
          plugins = {
            name = "plugins",
            module = "blink.compat.source",
          },
          conjure = {
            name = "conjure",
            module = "blink.compat.source",
          },
          otter = {
            name = "otter",
            module = "blink.compat.source",
          },
          colors = {
            name = "color_names",
            module = "blink.compat.source",
          },
          tex = {
            name = "vimtex",
            module = "blink.compat.source",
          },
          texsym = {
            name = "latex_symbols",
            module = "blink.compat.source",
          },
        },
      },
    },
  },
}
