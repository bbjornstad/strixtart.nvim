local quill = require("util.quill")

return quill({
  LEADER = "",
  diagnostics = {
    go = {
      next = "]d",
      previous = "[d",
    },
    breakpoint = {
      next = "]k",
      previous = "[k",
      stopped = "]K",
    },
  },
  history = { command = "q:" },
  operations = {
    LEADER = { append = "g" },
    evaluate = "E",
    exchange = "X",
    multiply = "M",
    replace = "R",
    sort = "S",
  },
  fm = {
    LEADER = { append = "<leader>" },
    explore = {
      LEADER = { append = "e" },
      explore = "e",
      split = "s",
      directories = "d",
      home = {
        LEADER = { append = "~" },
        directories = "d",
        explore = "e",
        split = "s",
      },
      prompt = {
        LEADER = { append = "/" },
        directories = "d",
        explore = "e",
        split = "s",
      },
      tree = {
        LEADER = { append = "t" },
        fs = "t",
        git = "g",
        remote = "r",
      },
      yazi = "z",
    },
    grep = { live = "/" },
    files = {
      LEADER = { append = "f" },
      find = "f",
      find_cwd = "F",
      recent = "r",
      recent_cwd = "R",
      config = "c",
      data = "d",
    },
  },
  move_window = {
    left = "<C-h>",
    right = "<C-l>",
    down = "<C-j>",
    up = "<C-k>",
  },
  buffers = {
    LEADER = { append = "<leader>b" },
    fuzz = "b",
    scope = "z",
  },
  weather = {
    LEADER = { append = "<leader>" },
    open = "W",
  },
})
