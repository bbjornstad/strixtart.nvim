local key_screenshot = require("keys.editor").silicon

return {
  {
    'michaelrommel/nvim-silicon',
    opts = {
      disable_defaults = false,
      debug = false,
      font = 'Berkeley Mono Variable=14',
      theme = 'kanagawa',
      pad_horiz = 96,
      pad_vert = 72,
      no_round_corner = true,
      no_window_controls = true,
      no_line_number = false,
      line_offset = function(args)
        return args.line1
      end,
      line_pad = 2,
      tab_width = 4,
      shadow_blur_radius = 16,
      shadow_offset_x = 8,
      shadow_offset_y = 8,
      gobble = true,
      num_separator = '\u{258f}',
      window_title = function()
        return vim.fn.fnamemodify(
          vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
          ":t"
        )
      end,
      output = function()
        return "./" .. os.date("!%Y-%m-%dT%H-%M-%SZ") .. "_code.png"
      end,
    },
    keys = {
      {
        key_screenshot.save,
        function()
          require("nvim-silicon").shoot()
        end,
        mode = { "v" },
        desc = "scrot:| save |=> selection",
      },
      {
        key_screenshot.copy,
        function()
          require("nvim-silicon").clip()
        end,
        mode = "v",
        desc = "scrot:| copy |=> selection",
      },
      {
        key_screenshot.file,
        function()
          require("nvim-silicon").file()
        end,
        mode = "v",
        desc = "scrot:| file |=> selection",
      },
      {
        key_screenshot.save,
        function()
          require("nvim-silicon").shoot()
        end,
        mode = "n",
        desc = "scrot:| save |=> buffer",
      },
      {
        key_screenshot.copy,
        function()
          require("nvim-silicon").clip()
        end,
        mode = "n",
        desc = "scrot:| copy |=> buffer",
      },
      {
        key_screenshot.file,
        function()
          require("nvim-silicon").file()
        end,
        mode = "n",
        desc = "scrot:| file |=> buffer",
      },
    },
  }
}
