local quill = require("util.quill")

return quill({
  LEADER = "<leader>h",
  tldr = "t",
  cheatsheet = "c",
  cheatsh = {
    LEADER = { append = "s" },
    search = "s",
    no_comments = "S",
    alt = "c",
  },
  vimhelp = "h",
})
