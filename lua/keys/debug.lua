local quill = require("util.quill")

return quill({
  LEADER = "<leader>D",
  adapters = "a",
  printer = "P",
  chainsaw = {
    LEADER = { append = "l" },
    message = "m",
    variable = "v",
    object = "o",
    assertion = "a",
    beep = "b",
    time = "t",
    debug = "d",
    remove = "r",
  },
  dap = {
    continue = "c",
    step_over = "o",
    step_into = "s",
    step_out = "S",
    breakpoint = {
      toggle = "b",
      set = "B",
      log = "l",
    },
    repl_open = "e",
    run_last = "r",
    hover = "k",
    preview = "p",
    frames = "f",
    scopes = "z",
  },
})
