---@diagnostic disable: missing-fields
local ncmp = "nvim-cmp"
local default_sources = {
  {
    name = "nvim_lsp",
    entry_filter = function(entry, ctx)
      local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]

      if kind == "Text" then
        return false
      end
      return true
    end,
  },
  {
    name = "snippets",
    keyword_length = 3,
  },
  { name = "dap" },
  {
    name = "look",
    option = {
      convert_case = true,
      loud = true,
    },
  },
  {
    name = "omni",
    option = {
      disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
    },
  },
  {
    name = "env",
    trigger_characters = { "$" },
  },
  {
    name = "dotenv",
    option = {
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
  {
    name = "buffer",
    keyword_length = 5,
  },
  {
    name = "async_path",
    keyword_length = 2,
    trigger_characters = { "/" },
  },
  {
    name = "fonts",
    keyword_length = 3,
    option = { space_filter = "-" },
  },
  { name = "copilot" },
  { name = "cmp_ai" },
  { name = "cody", },
}

return {
  {
    ncmp,
    version = false,
    opts = function(_, opts)
      local cmp = require("cmp")
      -- configure nvim-cmp sources.
      opts.sources = vim.list_extend(opts.sources or {}, default_sources)

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "buffer" },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
          { name = "async_path" },
          { name = "env" },
        }, {
          { name = "buffer" },
        }),
      })

      -- Next we have filetype specific completion sources, these should be
      -- added only when needed.
      cmp.setup.filetype({ "rust", "cargo" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "crates" },
        }),
      })
      cmp.setup.filetype(
        { "gitconfig", "gitcommit", "gitattributes", "gitignore", "gitrebase" },
        {
          sources = vim.list_extend(vim.deepcopy(default_sources), {
            { name = "git" },
          }),
        }
      )
      cmp.setup.filetype({ "css" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "cmp-tw2css" },
        }),
      })
      cmp.setup.filetype({ "sass", "scss" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "sass-variables" },
          { name = "cmp-tw2css" },
        }),
      })
      cmp.setup.filetype({ "lua" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "nvim_lua" },
          { name = "plugins" },
        }),
      })
      cmp.setup.filetype({ "clojure", "fennel", "python" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "conjure" },
        }),
      })
      cmp.setup.filetype({
        "html",
        "css",
        "js",
        "md",
        "org",
        "norg",
        "scss",
        "sass",
      }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "color_names" },
        }),
      })

      cmp.setup.filetype(
        { "markdown", "rmd", "quarto", "org", "norg", "latex", "tex", "bibtex" },
        {
          sources = vim.list_extend(vim.deepcopy(default_sources), {
            { name = "otter" },
            { name = "dictionary" },
            { name = "latex_symbols" },
          }),
        }
      )
      cmp.setup.filetype({ "latex", "tex", "bibtex" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "vimtex" },
        }),
      })
      cmp.setup.filetype({ "neorg", "norg" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "neorg" },
        }),
      })
    end,
  },
  -- explicitly list out the sources that we are installing for nvim-cmp. These
  -- match the list that is represented above, but with the added caveat that
  -- these are required in order to prevent timing mismatches when nvim-cmp
  -- loads upon vim startup.
  -- First Up: Core
  -- ==============
  { 'iguanacucumber/mag-nvim-lsp', name = 'cmp-nvim-lsp' },
  { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
  { "https://codeberg.org/FelipeLema/cmp-async-path" },
  { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
  { "iguanacucumber/mag-nvim-lua", name = 'cmp-nvim-lua', ft = "lua" },
  { "rcarriga/cmp-dap" },
  { "bydlw98/cmp-env" },
  { "SergioRibera/cmp-dotenv" },
  { "octaltree/cmp-look" },
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
    ft = { "gitrebase", "gitcommit", "gitattributes", "gitconfig", "gitignore" },
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
}
