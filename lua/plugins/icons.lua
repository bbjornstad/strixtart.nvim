local key_editor = require("keys.editor")
local key_iconpick = key_editor.glyph.picker
local key_uni = key_editor.glyph.unicode

return {
  {
    "2kabhishek/nerdy.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
    keys = {
      {
        key_editor.glyph.nerdy,
        "<CMD>Nerdy<CR>",
        mode = "n",
        desc = "glyph:| nerdfont |=> symbols",
      },
    },
  },
  {
    "ziontee113/icon-picker.nvim",
    cmd = {
      "IconPickerNormal",
      "IconPickerInsert",
      "IconPickerYank",
    },
    opts = {
      disable_legacy_commands = true,
    },
    keys = {
      {
        key_iconpick.normal.everything,
        "<CMD>IconPickerNormal<CR>",
        mode = "n",
        desc = "glyph:| pick |=> everything",
      },
      {
        key_iconpick.normal.icons,
        "<CMD>IconPickerNormal emoji nerd_font_v3 symbols<CR>",
        mode = "n",
        desc = "glyph:| pick |=> icons",
      },
      {
        key_iconpick.normal.emoji,
        "<CMD>IconPickerNormal emoji<CR>",
        mode = "n",
        desc = "glyph:| pick |=> emoji",
      },
      {
        key_iconpick.normal.nerd,
        "<CMD>IconPickerNormal nerd_font_v3<CR>",
        mode = "n",
        desc = "glyph:| icons |=> nerdfont",
      },
      {
        key_iconpick.normal.nerdv2,
        "<CMD>IconPickerNormal nerd_font<CR>",
        mode = "n",
        desc = "glyph:| icons |=> v2 nerdfont",
      },
      {
        key_iconpick.normal.symbols,
        "<CMD>IconPickerNormal symbols<CR>",
        mode = "n",
        desc = "glyph:| icons |=> symbols",
      },
      {
        key_iconpick.normal.altfont,
        "<CMD>IconPickerNormal alt_font<CR>",
        mode = "n",
        desc = "glyph:| icons |=> font (alt)",
      },
      {
        key_iconpick.normal.altfontsymbols,
        "<CMD>IconPickerNormal alt_font symbols<CR>",
        mode = "n",
        desc = "glyph:| icons |=> font and symbols (alt)",
      },
      {
        key_iconpick.yank.everything,
        "<CMD>IconPickerYank<CR>",
        mode = "n",
        desc = "glyph:| pick |=> everything",
      },
      {
        key_iconpick.yank.icons,
        "<CMD>IconPickerYank emoji nerd_font_v3 symbols<CR>",
        mode = "n",
        desc = "glyph:| pick |=> icons",
      },
      {
        key_iconpick.yank.emoji,
        "<CMD>IconPickerYank emoji<CR>",
        mode = "n",
        desc = "glyph:| pick |=> emoji",
      },
      {
        key_iconpick.yank.nerd,
        "<CMD>IconPickerYank nerd_font_v3<CR>",
        mode = "n",
        desc = "glyph:| icons |=> nerdfont",
      },
      {
        key_iconpick.yank.nerdv2,
        "<CMD>IconPickerYank nerd_font<CR>",
        mode = "n",
        desc = "glyph:| icons |=> v2 nerdfont",
      },
      {
        key_iconpick.yank.symbols,
        "<CMD>IconPickerYank symbols<CR>",
        mode = "n",
        desc = "glyph:| icons |=> symbols",
      },
      {
        key_iconpick.yank.altfont,
        "<CMD>IconPickerYank alt_font<CR>",
        mode = "n",
        desc = "glyph:| icons |=> font (alt)",
      },
      {
        key_iconpick.yank.altfontsymbols,
        "<CMD>IconPickerYank alt_font symbols<CR>",
        mode = "n",
        desc = "glyph:| icons |=> font and symbols (alt)",
      },
      {
        key_iconpick.insert.everything,
        "<CMD>IconPickerInsert<CR>",
        mode = "n",
        desc = "glyph:| pick |=> everything",
      },
      {
        key_iconpick.insert.icons,
        "<CMD>IconPickerInsert emoji nerd_font_v3 symbols<CR>",
        mode = "n",
        desc = "glyph:| pick |=> icons",
      },
      {
        key_iconpick.insert.emoji,
        "<CMD>IconPickerInsert emoji<CR>",
        mode = "n",
        desc = "glyph:| pick |=> emoji",
      },
      {
        key_iconpick.insert.nerd,
        "<CMD>IconPickerInsert nerd_font_v3<CR>",
        mode = "n",
        desc = "glyph:| icons |=> nerdfont",
      },
      {
        key_iconpick.insert.nerdv2,
        "<CMD>IconPickerInsert nerd_font<CR>",
        mode = "n",
        desc = "glyph:| icons |=> v2 nerdfont",
      },
      {
        key_iconpick.insert.symbols,
        "<CMD>IconPickerInsert symbols<CR>",
        mode = "n",
        desc = "glyph:| icons |=> symbols",
      },
      {
        key_iconpick.insert.altfont,
        "<CMD>IconPickerInsert alt_font<CR>",
        mode = "n",
        desc = "glyph:| icons |=> font (alt)",
      },
      {
        key_iconpick.insert.altfontsymbols,
        "<CMD>IconPickerInsert alt_font symbols<CR>",
        mode = "n",
        desc = "glyph:| icons |=> font and symbols (alt)",
      },
    },
  },
  {
    "chrisbra/unicode.vim",
    keys = {
      {
        key_uni.digraphs,
        "<CMD>Digraphs<CR>",
        mode = "n",
        desc = "glyph:| unicode |=> digraphs",
      },
      {
        key_uni.search,
        "<CMD>UnicodeSearch<CR>",
        mode = "n",
        desc = "glyph:| unicode |=> search",
      },
      {
        key_uni.search_add,
        "<CMD>UnicodeSearch!<CR>",
        mode = "n",
        desc = "glyph:| unicode |=> search>add",
      },
      {
        key_uni.name,
        "<CMD>UnicodeName<CR>",
        mode = "n",
        desc = "glyph:| unicode |=> name",
      },
      {
        key_uni.table,
        "<CMD>UnicodeTable<CR>",
        mode = "n",
        desc = "glyph:| unicode |=> table",
      },
      {
        key_uni.update,
        "<CMD>DownloadUnicode<CR>",
        mode = "n",
        desc = "glyph:| unicode |=> update data",
      },
    },
  },
  {
    "jonathanforhan/nvim-glyph",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    opts = {
      -- path of the vim digraph table
      digraph_table_path = vim.fn.expand("$VIMRUNTIME/doc/digraph.txt"),

      -- telescope style for popup
      telescope_style = "dropdown",

      -- these are the catagories that nvim-glyph defines to be excludable
      exclude_catagories = {
        -- 'GREEK',
        -- 'LATIN',
        -- 'CYRILLIC',
        -- 'HEBREW',
        -- 'ARABIC',
        -- 'BOX',
        -- 'JAPANESE',
        -- 'OTHER'
      },

      -- exclude these keywords for being display, still present for queries, however
      exclude_keywords = {
        "GREEK ",
        "LATIN ",
        "CYRILLIC ",
        "HEBREW ",
        "ARABIC ",
        "ARABIC%-INDIC ",
        "EXTENDED ",
        "VULGAR ",
        "HIRAGANA ",
        "KATAKANA ",
        "BOPOMOFO ",
        "CAPITAL ",
        "SMALL ",
        "LETTER ",
        "DIGIT ",
      },

      -- exclude certain digraph codes from being included
      exclude_code = {
        -- a digraph dec code (see ':h digraphs' for codes)
      },

      -- custom user-defined glyphs
      custom = {
        -- {
        --   value = ''                        -- any unicode (or any UTF-8 string for that matter)
        --   display = 'TUX'                    -- a description
        --   ordinal = 'query string' or nil    -- optional query string, will be the display if nil
        -- }
      },
    },
    keys = {
      {
        "<C-y>g",
        function()
          require("nvim-glyph").pick_glyph()
        end,
        mode = "i",
        desc = "glyph:| ext |=> pick",
      },
    },
  },
  {
    "echasnovski/mini.icons",
    version = false,
    event = "VeryLazy",
    opts = {}
  }

}
