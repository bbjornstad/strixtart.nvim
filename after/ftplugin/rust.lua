local quill = require("util.quill")

local key_rust = quill({
  led = {
    LEADER = "'",
    debuggable = "d",
    diagnostic = {
      LEADER = { append = "x" },
      explain = "x",
      render = "r",
      fly_check = "f",
    },
    runnable = "r",
    testable = "t",
    macro = {
      LEADER = { append = "m" },
      expand = "m",
      rebuild = "r",
    },
    action = {
      LEADER = { append = "a" },
      grouped = "a",
      hover = "A",
    },
    crates = {
      open_cargo = "c",
      graph = "g",
    },
    parent = "p",
    symbol = {
      workspace = "y",
      workspace_filtered = "f",
    },
    join_lines = "j",
    search = {
      LEADER = { append = "s" },
      query = "q",
      replace = "r",
    },
    view = {
      LEADER = { append = "v" },
      syntax_tree = "s",
      item_tree = "i",
      hir = "h",
      mir = "m",
      unpretty = {
        hir = "H",
        mir = "M",
      },
      memory_layout = "r",
    },
    docs = {
      view = "D",
    },
    reload = "r",
  },
  unled = {
    move = {
      up = "<C-S-u>",
      down = "<C-S-d>",
    },
    hover = "K",
  },
})
local omapx =
  require("util.keys").dmapx({ default = { buffer = 0, remap = false } })

local function omapn(lhs, rhs, opts)
  omapx("n", lhs, rhs, opts)
end

omapn(key_rust.led.debuggable, function()
  vim.cmd.RustLSP("debuggables")
end, {
  desc = {
    family = "debug",
    group = "debuggable",
    action = "open",
    scope = "buf",
  },
})

omapn(key_rust.led.runnable, function()
  vim.cmd.RustLSP("runnables")
end, {
  desc = {
    family = "run",
    group = "runnable",
    action = "open",
    scope = "buf",
  },
})

omapn(key_rust.led.testable, function()
  vim.cmd.RustLSP("testables")
end, {
  desc = {
    family = "test",
    group = "testable",
    action = "open",
    scope = "buf",
  },
})

omapn(key_rust.led.macro.expand, function()
  vim.cmd.RustLSP("expandMacro")
end, {
  desc = {
    family = "code",
    group = "macro",
    action = "expand recursive",
    scope = "buf",
  },
})

omapn(key_rust.led.macro.rebuild, function()
  vim.cmd.RustLSP("rebuildProcMacros")
end, {
  desc = {
    family = "code",
    group = "macro",
    action = "rebuild",
    scope = "buf",
  },
})

omapn(key_rust.led.action.grouped, function()
  vim.cmd.RustLSP("codeAction")
end, {
  desc = {
    family = "code",
    group = "action",
    action = "open",
    scope = "buf",
  },
})

omapn(key_rust.led.action.hover, function()
  vim.cmd.RustLSP({ "hover", "actions" })
end, {
  desc = {
    family = "code",
    group = "action",
    action = "hover",
    scope = "buf",
  },
})

omapn(key_rust.led.diagnostic.explain, function()
  vim.cmd.RustLSP("explainError")
end, {
  desc = {
    family = "diag",
    group = "error",
    action = "explain",
    scope = "buf",
  },
})

omapn(key_rust.led.diagnostic.render, function()
  vim.cmd.RustLSP("explainError")
end, {
  desc = {
    family = "diag",
    group = "all",
    action = "render",
    scope = "buf",
  },
})

omapn(key_rust.led.diagnostic.fly_check, function()
  vim.cmd.RustLSP("flyCheck")
end, {
  desc = {
    family = "diag",
    group = "check",
    action = "clippy",
    scope = "buf",
  },
})

omapn(key_rust.led.crates.open_cargo, function()
  vim.cmd.RustLSP("openCargo")
end, {
  desc = {
    family = "crate",
    group = "cargo",
    action = "open",
    scope = "buf",
  },
})

omapn(key_rust.led.parent, function()
  vim.cmd.RustLSP("parentModule")
end, {
  desc = {
    family = "code",
    group = "module",
    action = "parent",
    scope = "buf",
  },
})

omapn(key_rust.led.symbol.workspace, function()
  vim.cmd.RustLSP("workspaceSymbol")
end, {
  desc = {
    family = "lsp",
    group = "symbol",
    action = "workspace",
    scope = "buf",
  },
})

omapn(key_rust.led.symbol.workspace_filtered, function()
  vim.cmd.RustLSP("workspaceSymbol")
end, {
  desc = {
    family = "lsp",
    group = "symbol",
    action = "filtered",
    scope = "buf",
  },
})

omapn(key_rust.led.join_lines, function()
  vim.cmd.RustLSP("joinLines")
end, {
  desc = {
    family = "tool",
    group = "lines",
    action = "join",
    scope = "buf",
  },
})

omapn(key_rust.led.search.replace, function()
  vim.cmd.RustLSP("ssr")
end, {
  desc = {
    family = "sx",
    group = "replace",
    action = "structural",
    scope = "buf",
  },
})

omapn(key_rust.led.search.query, function()
  vim.cmd.RustLSP("ssr")
end, {
  desc = {
    family = "sx",
    group = "replace",
    action = "query",
    scope = "buf",
  },
})

omapn(key_rust.led.view.syntax_tree, function()
  vim.cmd.RustLSP("syntaxTree")
end, {
  desc = {
    family = "view",
    group = "tree",
    action = "syntax",
    scope = "buf",
  },
})

omapn(key_rust.led.crates.graph, function()
  vim.cmd.RustLSP({ "crateGraph", "[backend]", "[output]" })
end, {
  desc = {
    family = "view",
    group = "crate",
    action = "graph",
    scope = "buf",
  },
})

omapn(
  key_rust.led.view.hir,
  function()
    vim.cmd.RustLSP({ "view", "hir" })
  end,
  { desc = { family = "view", group = "ir", action = "hir", scope = "buf" } }
)

omapn(
  key_rust.led.view.mir,
  function()
    vim.cmd.RustLSP({ "view", "mir" })
  end,
  { desc = { family = "view", group = "ir", action = "mir", scope = "buf" } }
)

omapn(key_rust.led.view.unpretty.hir, function()
  vim.cmd.RustLSP({ "unpretty", "hir" })
end, {
  desc = {
    family = "view",
    group = "ir",
    action = "unpretty hir",
    scope = "buf",
  },
})

omapn(key_rust.led.view.unpretty.mir, function()
  vim.cmd.RustLSP({ "unpretty", "mir" })
end, {
  desc = {
    family = "view",
    group = "ir",
    action = "unpretty mir",
    scope = "buf",
  },
})

omapn(key_rust.led.view.memory_layout, function()
  local fn = require("ferris.methods.view_memory_layout")
  fn()
end, {
  desc = {
    family = "view",
    group = "mem",
    action = "layout",
    scope = "buf",
  },
})

omapn(key_rust.led.docs.view, function()
  local fn = require("ferris.methods.open_documentation")
  fn()
end, {
  desc = {
    family = "view",
    group = "ir",
    action = "unpretty hir",
    scope = "buf",
  },
})

omapn(
  key_rust.led.view.item_tree,
  function()
    local fn = require("ferris.methods.view_item_tree")
    fn()
  end,
  { desc = { family = "view", group = "tree", action = "item", scope = "buf" } }
)

omapn(key_rust.led.reload, function()
  local fn = require("ferris.methods.reload_workspace")
  fn()
end, {
  desc = {
    family = "code",
    group = "space",
    action = "reload",
    scope = "buf",
  },
})
