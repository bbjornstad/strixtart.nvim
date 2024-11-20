local lang = require("util.lang")
local lz_opts = require("util.lazy").opts

local key_lsp = require("keys.lsp")
local key_util = require("util.keys")
local uienv = require("env.ui")

local function generate_capabilities(...)
  local cap = vim.tbl_deep_extend("force", {}, {}, ...)

  return cap
end

local function generate_keymaps(opts)
  opts = opts or {}

  local zero = require("lsp-zero")

  local zero_handler = function(client, bufnr)
    zero.default_keymaps(vim.tbl_deep_extend("force", {
      buffer = bufnr,
    }, opts))
  end
  local lsp_handler = function(client, bufnr)
    local mapn = key_util.by_mode("n", {
      buffer = bufnr,
    })

    mapn(key_lsp.format.zero, function()
      require("lsp-zero").async_autoformat(client, bufnr, {})
    end, { desc = "lsp:buf| fmt |=> apply zero" })
    mapn(
      key_lsp.code.action,
      vim.lsp.buf.code_action,
      { desc = "lsp:| act |=> code actions" }
    )
    mapn(
      key_lsp.rename,
      vim.lsp.buf.rename,
      { desc = "lsp:| act |=> rename symb" }
    )
    mapn(
      key_lsp.info,
      "<CMD>check lspconfig<CR>",
      { desc = "lsp:| info |=> servers" }
    )
    mapn(key_lsp.log, "<CMD>LspLog<CR>", { desc = "lsp:| log |=> view" })
    mapn(
      key_lsp.diagnostic.buffer,
      vim.diagnostic.open_float,
      { desc = "lsp:| diag |=> float" }
    )
    mapn(
      key_lsp.go.type_definition,
      vim.lsp.buf.type_definition,
      { desc = "lsp:| go |=> type definition" }
    )
    mapn(
      key_lsp.go.signature_help,
      vim.lsp.buf.signature_help,
      { desc = "lsp:| go |=> signature help" }
    )
    mapn(
      key_lsp.go.definition,
      vim.lsp.buf.definition,
      { desc = "lsp:| go |=> definition" }
    )
    mapn(
      key_lsp.go.references,
      vim.lsp.buf.references,
      { desc = "lsp:| go |=> references" }
    )
    mapn(
      key_lsp.go.implementation,
      vim.lsp.buf.implementation,
      { desc = "lsp:| go |=> implementation" }
    )
    mapn(
      key_lsp.calls.incoming,
      vim.lsp.buf.incoming_calls,
      { desc = "lsp:| calls |=> incoming" }
    )
    mapn(
      key_lsp.calls.outgoing,
      vim.lsp.buf.outgoing_calls,
      { desc = "lsp:| calls |=> outgoing" }
    )
  end

  return function(client, bufnr)
    zero_handler(client, bufnr)
    lsp_handler(client, bufnr)
  end
end

local function generate_attach_handler(opts)
  local newts = require("util.newts")
  opts = opts or {}

  local keymaps = opts.keymaps ~= nil and opts.keymaps or {}
  local status = opts.lsp_status ~= nil and opts.lsp_status or {}
  local vtypes = opts.virtual_types ~= nil and opts.virtual_types or {}
  local hints = opts.inlay_hints ~= nil and opts.inlay_hints or {}

  local attach_handler = function(client, bufnr)
    if keymaps then
      local keymap_handler = generate_keymaps(keymaps)
      keymap_handler(client, bufnr)
    end
    if status then
      local ok, attach_result = pcall(require("lsp-status").on_attach, client)
      if not ok then
        newts.warn(
          [[
        Failed attaching lsp-status for server %s with result: %s
        ]],
          client,
          attach_result
        )
      end
    end
    if vtypes and client.supports_method("textDocument/codeLens") then
      local ok, attach_result =
        pcall(require("virtualtypes").on_attach, client, bufnr)
      if not ok then
        newts.warn(
          [[
        Failed attaching virtual-types for server %s with result: %s
        ]],
          client,
          attach_result
        )
      end
    end
    if hints and client.supports_method("textDocument/inlayHint") then
      local ok, attach_result =
        pcall(require("util.toggle").inlay_hints, bufnr, true)
      if not ok then
        newts.warn(
          [[
        Failed attaching inlay-hints for server %s with result: %s
        ]],
          client,
          attach_result
        )
      end
    end
  end

  return attach_handler
end

return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v4.x",
    config = function(_, opts) end,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    -- lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "saghen/blink.cmp" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "folke/neoconf.nvim" },
      { "folke/lazydev.nvim" },
      { "nvim-lua/lsp-status.nvim" },
      { "jubnzv/virtual-types.nvim" },
    },
    config = function(_, opts)
      local zero = require("lsp-zero")

      opts = opts or {}

      opts.sign_text = opts.sign_text ~= nil and opts.sign_text or true
      opts.sign_text = (type(opts.sign_text) == "table" and opts.sign_text)
        or (opts.sign_text == true and uienv.icons.diagnostic)
        or {}

      opts.mason = opts.mason ~= nil and opts.mason or {}

      opts.inlay_hints = opts.inlay_hints or {}

      opts.codelens = opts.codelens or {}

      opts.document_highlight = opts.document_highlight or {}

      opts.diagnostics = opts.diagnostics or {}

      zero.extend_lspconfig({
        sign_text = vim.tbl_deep_extend(
          "force",
          uienv.icons.diagnostic,
          opts.sign_text
        ),
        lsp_attach = generate_attach_handler(opts),
        capabilities = generate_capabilities(
          opts.capabilities or {},
          require("blink.cmp").get_lsp_capabilities({}, true)
        ),
        float_border = uienv.borders.main,
      })

      local neoconf_plugin =
        require("lazy.core.config").spec.plugins["neoconf.nvim"]
      require("neoconf").setup(
        require("lazy.core.plugin").values(neoconf_plugin, "opts", false)
      )

      local mason_lspconfig = require("mason-lspconfig")
      local mason_lspconfig_opts = lz_opts("mason-lspconfig.nvim")
      mason_lspconfig.setup(mason_lspconfig_opts)

      opts.servers = opts.servers or {}
      for nm_lang, srv in pairs(opts.servers) do
        vim.print(srv)
        srv()
      end
    end,
  },
}
