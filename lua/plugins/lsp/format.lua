local lang = require("util.lang")

local key_format = require("keys.format")

local slow_format_filetypes = {}

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        ["*"] = { "injected" },
        ["_"] = { "trim_newlines", "trim_whitespace" },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        if slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end

        local function on_format(err)
          if err and err:match("timeout$") then
            slow_format_filetypes[vim.bo[bufnr].filetype] = true
          end
        end

        return { timeout_ms = 1000, lsp_fallback = true }, on_format
      end,
      format_after_save = function(bufnr)
        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        return { lsp_fallback = true }
      end,
      log_level = vim.log.levels.WARN,
      notify_on_error = true,
    },
    config = function(_, opts)
      require("conform.formatters.injected").options.ignore_errors = true

      require("conform").setup(opts)

      -- defines new format command
      vim.api.nvim_create_user_command("StrixFormat", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line =
            vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({
          async = args.bang,
          lsp_fallback = true,
          range = range,
        })
      end, { bang = true, desc = "󱡠 lsp:buf| fmt |=> apply" })
      vim.api.nvim_create_user_command("StrixFormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, { desc = "󱡠 lsp:buf| fmt.auto |=> disable", bang = true })
      vim.api.nvim_create_user_command("StrixFormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "󱡠 lsp:buf| fmt.auto |=> enable" })
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    keys = {
      {
        key_format.default,
        function()
          require("conform").format({ async = true })
        end,
        mode = "n",
        desc = "lsp:buf| fmt |=> apply",
      },
      {
        key_format.list,
        function()
          local buf = vim.api.nvim_get_current_buf()
          require("conform").list_formatters(buf)
        end,
        mode = "n",
        desc = "lsp:buf| fmt |=> list formatters",
      },
      {
        key_format.info,
        "<CMD>ConformInfo<CR>",
        mode = "n",
        desc = "lsp:| fmt |=> info",
      },
    },
  },
}
