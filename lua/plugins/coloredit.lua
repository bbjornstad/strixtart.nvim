local key_color = require("keys.color")
local uienv = require("env.ui")

return {
  {
    "NvChad/nvim-colorizer.lua",
    enabled = false,
    event = "VeryLazy",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        names = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        sass = { enable = true, parsers = { "css" } },
        virtualtext = "󰐮 ",
        always_update = true,
      },
    },
    cmd = {
      "ColorizerAttachToBuffer",
      "ColorizerReloadAllBuffers",
      "ColorizerToggle",
    },
    keys = {
      {
        key_color.inline_hl.toggle,
        "<CMD>ColorizerToggle<CR>",
        mode = "n",
        desc = "color:| hl |=> toggle",
      },
      {
        key_color.inline_hl.detach,
        "<CMD>ColorizerDetachFromBuffer<CR>",
        mode = "n",
        desc = "color:| hl |=> detach",
      },
      {
        key_color.inline_hl.attach,
        "<CMD>ColorizerAttachToBuffer<CR>",
        mode = "n",
        desc = "color:| hl |=> attach",
      },
      {
        key_color.inline_hl.reload,
        "<CMD>ColorizerReloadAllBuffers<CR>",
        mode = "n",
        desc = "color:| hl |=> reload",
      },
    },
  },
  {
    "echasnovski/mini.colors",
    event = "VeryLazy",
    version = false,
    keys = {
      {
        key_color.convert.hex,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "hex")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> hex",
      },
      {
        key_color.convert.rgb,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "rgb")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> rgb",
      },
      {
        key_color.convert.eightbit,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "8-bit")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> 8-bit",
      },
      {
        key_color.convert.oklab,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "oklab")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> oklab",
      },
      {
        key_color.convert.oklch,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "oklch")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> oklch",
      },
      {
        key_color.convert.okhsl,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "okhsl")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> okhsl",
      },
      {
        key_color.convert.select,
        function()
          local col = vim.fn.expand("<cword>")
          vim.ui.select(
            { "8-bit", "hex", "rgb", "oklab", "oklch", "okhsl" },
            { prompt = "colorspace: " },
            function(sel)
              local conv = require("mini.colors").convert(col, sel)
              local row, column = unpack(vim.api.nvim_win_get_cursor(0))
              vim.api.nvim_buf_set_text(
                0,
                row,
                column,
                row,
                column,
                vim.iter({ conv }):flatten():totable()
              )
            end
          )
        end,
        mode = "n",
        desc = "color:| convert |=> select",
      },
      {
        key_color.interactive,
        function()
          require("mini.colors").interactive()
        end,
        mode = "n",
        desc = "color:| play |=> interactive",
      },
    },
  },
  {
    "nvim-colortils/colortils.nvim",
    opts = {
      border = uienv.borders.main,
    },
    cmd = "Colortils",
    keys = {
      {
        key_color.pick,
        "<CMD>Colortils picker<CR>",
        mode = "n",
        desc = "color:| select |=> pick",
      },
      {
        key_color.lighten,
        "<CMD>Colortils lighten<CR>",
        mode = "n",
        desc = "color:| mod |=> lighten",
      },
      {
        key_color.darken,
        "<CMD>Colortils darken<CR>",
        mode = "n",
        desc = "color:| mod |=> darken",
      },
      {
        key_color.greyscale,
        "<CMD>Colortils greyscale<CR>",
        mode = "n",
        desc = "color:| mod |=> greyscale",
      },
      {
        key_color.list,
        "<CMD>Colortils css list<CR>",
        mode = "n",
        desc = "color:| list |=> css",
      },
    },
  },
  {
    "NvChad/minty",
    dependencies = { "NvChad/volt" },
    cmd = { "Shades", "Huefy" },
    opts = {
      huefy = {
        border = true,
      },
      shades = {
        border = true,
      },
    },
    keys = {
      {
        key_color.huefy.open,
        function()
          require("minty.huefy").open()
        end,
        mode = "n",
        desc = "color:| huefy |=> open",
      },
      {
        key_color.huefy.save,
        function()
          require("minty.huefy").save_color()
        end,
        mode = "n",
        desc = "color:| huefy |=> save",
      },
      {
        key_color.shades.open,
        function()
          require("minty.shades").open()
        end,
        mode = "n",
        desc = "color:| shades |=> open",
      },
      {
        key_color.shades.save,
        function()
          require("minty.shades").save_color()
        end,
        mode = "n",
        desc = "color:| shades |=> save",
      },
      {
        key_color.util.lighten,
        function()
          require("minty.utils").lighten_on_cursor(vim.v.count or 1)
        end,
        mode = "n",
        desc = "color:| lighten |=> lighten",
      },
      {
        key_color.util.darken,
        function()
          require("minty.utils").lighten_on_cursor((-1 * vim.v.count) or -1)
        end,
        mode = "n",
        desc = "color:| darken |=> darken",
      },
    },
  },
  {
    "uga-rosa/ccc.nvim",
    opts = function()
      return {
        default_color = "#000000",
        bar_char = "▓",
        point_char = "󰋙",
        bar_len = 42,
        auto_close = true,
        save_on_quit = true,
        preserve = true,
        alpha_show = "auto",
        highlight_mode = "virtual",
        virtual_symbol = "󰀽",
        win_opts = {
          relative = "cursor",
          row = 1,
          col = 1,
          style = "minimal",
          border = uienv.borders.main,
        },
        highlighter = {
          auto_enable = true,
          max_byte = 100 * 1024,
          lsp = true,
          update_insert = true,
        },
        inputs = {
          require("ccc").input.rgb,
          require("ccc").input.hsl,
          require("ccc").input.hwb,
          require("ccc").input.lab,
          require("ccc").input.lch,
          require("ccc").input.oklab,
          require("ccc").input.oklch,
          require("ccc").input.cmyk,
          require("ccc").input.hsluv,
          require("ccc").input.okhsl,
          require("ccc").input.hsv,
          require("ccc").input.okhsv,
          require("ccc").input.xyz,
        },
        outputs = {
          require("ccc").output.hex,
          require("ccc").output.hex_short,
          require("ccc").output.css_rgb,
          require("ccc").output.css_hsl,
          require("ccc").output.css_hwb,
          require("ccc").output.css_lab,
          require("ccc").output.css_lch,
          require("ccc").output.css_oklab,
          require("ccc").output.css_oklch,
          require("ccc").output.float,
        },
        convert = {
          { require("ccc").picker.hex, require("ccc").output.css_rgb },
          { require("ccc").picker.css_rgb, require("ccc").output.css_hsl },
          { require("ccc").picker.css_hsl, require("ccc").output.hex },
        },
        recognize = {
          input = true,
          output = true,
          pattern = {
            [require("ccc").picker.css_rgb] = {
              require("ccc").input.rgb,
              require("ccc").output.rgb,
            },
            [require("ccc").picker.css_name] = {
              require("ccc").input.rgb,
              require("ccc").output.rgb,
            },
            [require("ccc").picker.hex] = {
              require("ccc").input.rgb,
              require("ccc").output.hex,
            },
            [require("ccc").picker.css_hsl] = {
              require("ccc").input.hsl,
              require("ccc").output.css_hsl,
            },
            [require("ccc").picker.css_hwb] = {
              require("ccc").input.hwb,
              require("ccc").output.css_hwb,
            },
            [require("ccc").picker.css_lab] = {
              require("ccc").input.lab,
              require("ccc").output.css_lab,
            },
            [require("ccc").picker.css_lch] = {
              require("ccc").input.lch,
              require("ccc").output.css_lch,
            },
            [require("ccc").picker.css_oklab] = {
              require("ccc").input.oklab,
              require("ccc").output.css_oklab,
            },
            [require("ccc").picker.css_oklch] = {
              require("ccc").input.oklch,
              require("ccc").output.css_oklch,
            },
          },
        },
        mappings = {},
      }
    end,
    keys = {
      {
        key_color.pick,
        "<CMD>CccPick<CR>",
        mode = "n",
        desc = "color:| ccc |=> pick",
      },
      {
        key_color.convert.select,
        "<CMD>CccConvert<CR>",
        mode = "n",
        desc = "color:| ccc |=> convert",
      },
      {
        key_color.inline_hl.toggle,
        "<CMD>CccHighlighterToggle<CR>",
        mode = "n",
        desc = "color:| inline |=> toggle",
      },
    },
    cmd = {
      "CccPick",
      "CccConvert",
      "CccHighlighterEnable",
      "CccHighlighterToggle",
    },
  },
}
