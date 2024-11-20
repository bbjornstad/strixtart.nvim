local quill = require("util.quill")

local leader_repl = "'"

return quill({
  LEADER = leader_repl,
  jackin = {
    LEADER = { append = "j" },
    clj = "c",
    lein = "l",
  },
  iron = {
    LEADER = { append = "r" },
    filetype = "s",
    restart = "r",
    focus = "f",
    hide = "q",
  },
  vlime = "v",
  acid = "a",
  conjure = "c",
  jupyter = {
    LEADER = { append = "j" },
    attach = "a",
    detach = "d",
    execute = "x",
    inspect = "k",
  },
  sniprun = {
    LEADER = { append = "s" },
    line = "O",
    operator = "o",
    run = "s",
    info = "i",
    close = "q",
    live = "l",
  },
  molten = {
    LEADER = { append = "m" },
    evaluate = {
      line = "l",
      visual = "e",
      cell = "r",
    },
    delete = "d",
    show = "s",
  },
  yarepl = {
    LEADER = { append = "y" },
    start = "s",
    attach_buffer = "a",
    detach_buffer = "d",
    focus = "f",
    hide = "h",
    hide_or_focus = "e",
    close = "q",
    swap = "w",
    send_visual = "v",
    send_line = "l",
    send_operator = "o",
    exec = "x",
    cleanup = "c",
  },
})
