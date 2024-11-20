local env = require("env.ui")

local WIDE_HEIGHT = 40

return {
  {
    "nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim",
      "luckasRanarison/tailwind-tools.nvim",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local has = require("util.lazy").has
      local cmp_format = require("lspkind").cmp_format({
        mode = "symbol_text",
        maxwidth = 80,
        menu = {
          nvim_lsp = "⟪ lsp ⟫",
          color_names = "⟪ col ⟫",
          natdat = "⟪ dt ⟫",
          digraphs = "⟪ digr ⟫",
          gitlog = "⟪ git ⟫",
          fonts = "⟪ font ⟫",
          env = "⟪ env ⟫",
          calc = "⟪ calc ⟫",
          ctags = "⟪ ctag ⟫",
          emoji = "⟪ emoji ⟫",
          nvim_lsp_signature_help = "⟪ sig ⟫",
          nvim_lua = "⟪ lua ⟫",
          fuzzy_path = "⟪ fuzz ⟫",
          nvim_lsp_document_symbol = "⟪ symb ⟫",
          rg = "⟪ rg ⟫",
          buffer = "⟪ buf ⟫",
          luasnip = "⟪ snip ⟫",
          look = "⟪ look ⟫",
          ["diag-codes"] = "⟪ diag ⟫",
          treesitter = "⟪ tree ⟫",
          nerdfonts = "⟪ nerds ⟫",
          nerdfont = "⟪ nerd ⟫",
          AI = "⟪ aiml ⟫",
          spell = "⟪ spell ⟫",
          ["cmp-dap"] = "⟪ dap ⟫",
          omni = "⟪ omni ⟫",
          latex_symbol = "⟪ tex ⟫",
          ["cmp-tw2css"] = "⟪ tw ⟫",
          pandoc_references = "⟪ pan ⟫",
          zsh = "⟪ zsh ⟫",
          cmdline = "⟪ cmd ⟫",
          dictionary = "⟪ dict ⟫",
          path = "⟪ path ⟫",
          codeium = "⟪ codi ⟫",
          copilot = "⟪ cplt ⟫",
          tabnine = "⟪ nine ⟫",
          plugins = "⟪ plg ⟫",
        },
        symbol_map = {
          Codeium = "󱟬",
          AI = "󱁊",
          Copilot = "",
        },
        before = require("tailwind-tools.cmp").lspkind_format,
      })
      -- The following changes the appearance of the menu. Noted changes:
      -- * different row field order
      -- * vscode codicons
      -- * vscode-styled colors
      opts.formatting = vim.tbl_deep_extend("force", {
        fields = {
          cmp.ItemField.Menu,
          cmp.ItemField.Abbr,
          cmp.ItemField.Kind,
        },
        format = cmp_format,
      }, opts.formatting or {})
      -- set up window parameters and other main display settings. I don't know
      -- why the documentation is not following the same pattern. Padding does
      -- not seem to be applied.
      opts.window = vim.tbl_deep_extend("force", {
        completion = {
          border = env.borders.main,
          winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
          winblend = vim.o.pumblend,
          col_offset = 0,
          scrolloff = 2,
          side_padding = 1,
          scrollbar = true,
        },
        documentation = {
          max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
          max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
          border = env.borders.main,
          scrolloff = 4,
          winhighlight = 'FloatBorder:NormalFloat',
          winblend = vim.o.pumblend,
          col_offset = 0,
        },
      }, opts.window or {})
    end,
  },
}
