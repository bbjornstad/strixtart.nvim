local quill = require("util.quill")

return quill({
  LEADER = "<leader>l",
  quickfix = {
    LEADER = { append = "q" },
    open = "q",
    close = "Q",
    next = "n",
    previous = "p",
    first = "f",
    last = "e",
  },
  loclist = {
    LEADER = { append = "l" },
    open = "l",
    close = "Q",
    next = "n",
    previous = "p",
    first = "f",
    last = "e",
  },
  replacer = "r",
})
