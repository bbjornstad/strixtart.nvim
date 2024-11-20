local quill = require("util.quill")

return quill({
  LEADER = "<leader>u",
  color = {
    LEADER = { append = "C" },
    pineapple = "C",
  },
  easyread = "B",
  block = "b",
  signs = {
    LEADER = { append = "s" },
    actions = {
      toggle = "a",
      toggle_label = "A",
    },
  },
  spelling = "z",
  bionic = "B",
  numbers = {
    LEADER = { append = "n" },
    line = "n",
    relative = "r",
  },
  pairs = "P",
  wrap = "w",
  diagnostics = {
    LEADER = { append = "d" },
    toggle = "d",
    toggle_lines = "l",
    corn = {
      LEADER = { append = "c" },
      toggle = "C",
      file = "f",
      line = "l",
      cycle = "c",
    },
  },
  matchparen = {
    LEADER = { append = "m" },
    enable = "m",
    disable = "d",
  },
  focus = "f",
  hlslens = "e",
  eyeliner = "F",
  conceal = "c",
  inlay_hints = "h",
  centerscroll = "R",
  treesitter = "T",
  pinbuf = "p",
  background = "D",
})
