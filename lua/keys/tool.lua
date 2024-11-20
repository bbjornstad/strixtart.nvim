local quill = require("util.quill")

return quill({
  LEADER = "<leader>",
  snippet = {
    LEADER = { append = "N" },
    add = "a",
    edit = "e",
  },
  regex = {
    LEADER = { append = "R" },
    explainer = "r",
    hypersonic = "h",
  },
  splitjoin = {
    LEADER = { append = "j" },
    split = "s",
    join = "o",
    toggle = "j",
  },
  glow = "P",
  preview = "P",
  notice = "N",
  remote = {
    LEADER = { append = "r" },
    sshfs = {
      LEADER = { append = "s" },
      connect = "c",
      edit = "e",
      disconnect = "d",
      find_files = "f",
      live_grep = "g",
    },
  },
  rest = {
    LEADER = { append = "r" },
    open = "o",
    preview = "p",
    last = "l",
    log = "g",
  },
  mpv = {
    LEADER = { append = "V" },
    toggle = "V",
  },
})
