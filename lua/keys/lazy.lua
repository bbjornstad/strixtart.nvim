local quill = require("util.quill")

return quill({
  LEADER = "<leader>L",
  log = "l",
  extras = "e",
  open = "L",
  sync = "s",
  update = "u",
  clean = "x",
  debug = "d",
  health = "h",
  help = "H",
  build = "b",
  check = "c",
  clear = "C",
  profile = "p",
  reload = "r",
  restore = "R",
  root = "/",
  install = "i",
})
