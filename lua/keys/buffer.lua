local quill = require("util.quill")

return quill({
  LEADER = "<leader>b",
  next = "n",
  previous = "p",
  close = "q",
  write = "w",
  writeall = "W",
  wipeout = "o",
  force_wipeout = "O",
  force_quit = "Q",
  write_quit = "W",
  delete = "d",
  delete_others = "r",
  force_delete = "D",
  force_delete_others = "R",
  wipe_others = "e",
  force_wipe_others = "E",
  telescope = { scope = "B" },
  jabs = "j",
  hbac = {
    LEADER = { append = "a" },
    pin = {
      toggle = "p",
      unpin_all = "u",
      close_unpinned = "c",
      all = "P",
    },
    telescope = "t",
  },
})
