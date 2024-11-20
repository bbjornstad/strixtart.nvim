local lang = require("util.lang")

local lua = lang.language("lua", "lua", { mason = true })
local spec = {
  lua
    :server("lua_ls", {
      handler = function()
        require("lspconfig").lua_ls.setup(require("lsp-zero").nvim_lua_ls({
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = true,
              },
              diagnostics = {
                globals = { "vim" },
              },
              completions = {
                callSnippet = "both",
              },
              hint = {
                enable = true,
                setType = true,
                arrayIndex = "Enable",
                paramType = true,
                await = true,
                codeLens = {
                  paramName = "All",
                  semicolon = "SameLine",
                },
              },
              runtime = {
                version = "LuaJIT",
              },
            },
          },
        }))
      end,
      ensure_installed = { "lua_ls" },
    })
    :linter("selene")
    :formatter("stylua")
    :tolazy(),
}

return {
  unpack(spec),
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        path = "luvit-meta/library",
        words = { "vim%.uv" },
      },
    },
    dependencies = {
      { "Bilal2453/luvit-meta" },
    },
    specs = {
      {
        "nvim-cmp",
        opts = function(_, opts)
          opts.sources = opts.sources or {}
          table.insert(opts.sources, {
            name = "lazydev",
            group_index = 0,
          })
        end,
      },
      {
        "saghen/blink.cmp",
        opts = {
          sources = {
            completion = {
              enabled_providers = {
                "lazydev",
              },
            },
          },
          providers = {
            lazydev = {
              name = "lazydev",
              module = "lazydev.integrations.blink",
            },
            lsp = {
              fallback_for = { "lazydev" },
            },
          },
        },
      },
    },
    cmd = { "LazyDev" },
  },
  {
    "folke/neoconf.nvim",
    opts = {
      plugins = {
        lua_ls = {
          enabled_for_neovim_config = true,
          enabled = true,
        },
      },
    },
  },
  {
    "danymat/neogen",
    opts = {
      languages = {
        lua = {
          template = {
            annotation_convention = "emmylua",
          },
        },
      },
    },
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    config = function()
      local dap = require("dap")
      dap.adapters.nlua = function(callback, conf)
        local adapter = {
          type = "server",
          host = conf.host or "127.0.0.1",
          port = conf.port or 8086,
        }
        if conf.start_neovim then
          local dap_run = dap.run
          dap.run = function(c)
            adapter.port = c.port
            adapter.host = c.host
          end
          require("osv").run_this()
          dap.run = dap_run
        end
        callback(adapter)
      end
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Run this file",
          start_neovim = {},
        },
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance (port = 8086)",
          port = 8086,
        },
      }
    end,
  },
  {
    "YaroSpace/lua-console.nvim",
    opts = {
      buffer = {
        prepend_result_with = "=> ",
        save_path = vim.fn.stdpath("state") .. "/lua-console.lua",
        load_on_start = true, -- load saved session on first entry
      },
      window = {
        anchor = "SW",
        border = "double", -- single|double|rounded
        height = 0.6, -- percentage of main window
        zindex = 1,
      },
      mappings = {
        toggle = "<C-~>",
        quit = "q",
        eval = "<CR>",
        clear = "C",
        messages = "M",
        save = "S",
        load = "L",
        resize_up = "<C-Up>",
        resize_down = "<C-Down>",
        help = "?",
      },
    },
    ft = { "lua" },
  },
}
