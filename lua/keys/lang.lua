local quill = require("util.quill")

local leader_lang = "`"

return quill({
  LEADER = "",
  yaml = {
    LEADER = { append = leader_lang },
    schema = "y",
  },
  python = {
    LEADER = { append = leader_lang },
    fstring_toggle = "f",
    ipynb = {
      LEADER = { append = "y" },
    },
  },
  api = {
    LEADER = { append = leader_lang .. "a" },
    endpoint = {
      go = "g",
      recents = "r",
      list = "a",
    },
    refresh = "r",
    select = "s",
    select_env = "e",
    remote_env = "R",
  },
  rust = {
    led = {
      LEADER = { append = leader_lang },
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
  },
})
