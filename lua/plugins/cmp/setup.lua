---@diagnostic disable: missing-fields
local ncmp = "iguanacucumber/magazine.nvim"
local kenv = require("keys.completion")

local function toggle_cmp_enabled()
  local status = vim.b.enable_cmp_completion or vim.g.enable_cmp_completion
  status = not status
  vim.notify(("nvim-cmp: %s"):format(status and "enabled" or "disabled"))
  ---@diagnostic disable-next-line: inject-field
  vim.b.enable_cmp_completion = status
end

local function toggle_cmp_autocompletion()
  local status = vim.b.enable_cmp_autocompletion
    or vim.g.enable_cmp_autocompletion
  status = not status
  if status then
    require("cmp").setup.buffer({
      completion = {
        autocomplete = {
          require("cmp").TriggerEvent.InsertEnter,
          require("cmp").TriggerEvent.TextChanged,
        },
      },
    })
  else
    require("cmp").setup.buffer({
      autocomplete = false,
    })
  end
  ---@diagnostic disable-next-line: inject-field
  vim.b.enable_cmp_autocompletion = status
  vim.notify(("Autocompletion: %s"):format(vim.b.enable_cmp_autocompletion))
end

local function initialize_autocompletion()
  if vim.g.enable_cmp_autocompletion then
    return {
      require("cmp").TriggerEvent.InsertEnter,
      require("cmp").TriggerEvent.TextChanged,
    }
  end
  return false
end

return {
  {
    'nvim-cmp',
    url = 'https://github.com/iguanacucumber/magazine.nvim.git',
    pin = true,
    dependencies = { "garymjr/nvim-snippets" },
    init = function()
      vim.g.enable_cmp_completion = true
      vim.g.enable_cmp_autocompletion = true
    end,
    events = { "InsertEnter", "CmdlineEnter" },
    opts = function(_, opts)
      -- dynamic enablements of cmp
      opts.enabled = opts.enabled
        or function()
          return vim.b.enable_cmp_completion or vim.g.enable_cmp_completion
        end
      -- sets the correct snippet invocation based on the plugin choice that we
      -- have made regarding completion.
      opts.snippet = vim.tbl_deep_extend("force", {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      }, opts.snippet or {})
      -- performance improvements
      opts.performance = vim.tbl_deep_extend("force", {
        debounce = 0,
        throttle = 30,
        fetching_timeout = 500,
        filtering_context_budget = 3,
        confirm_resolve_timeout = 80,
        async_budget = 1,
        max_view_entries = 400,
      }, opts.performance or {})
      -- completeopt/general completion behavior
      opts.completion = vim.tbl_deep_extend("force", {
        autocomplete = initialize_autocompletion(),
        completeopt = "menu,menuone,noinsert",
      }, opts.completion or {})
      opts.preselect = require("cmp").PreselectMode.None
      opts.view = vim.tbl_deep_extend("force", {
        entries = {
          name = 'custom',
          selection_order = "near_cursor",
          follow_cursor = true,
        },
        docs = {
          auto_open = true,
        },
      }, opts.view or {})
      opts.experimental = vim.tbl_deep_extend("force", opts.experimental or {}, {
        ghost_text = true,
      })
    end,
    keys = {
      {
        kenv.toggle.enabled,
        toggle_cmp_enabled,
        mode = "n",
        desc = "cmp=> toggle nvim-cmp enabled",
      },
      {
        kenv.toggle.autocompletion,
        toggle_cmp_autocompletion,
        mode = "n",
        desc = "cmp=> toggle autocompletion on insert",
      },
    },
  },
}
