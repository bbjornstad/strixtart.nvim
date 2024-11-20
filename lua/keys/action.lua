local quill = require("util.quill")

return quill({
  LEADER = "<leader>a",
  preview = "p",
  apply_first = "A",
  code_action = "a",
  quickfix = {
    LEADER = { append = "q" },
    quickfix = "q",
    next = "n",
    previous = "p",
  },
  refactor = {
    LEADER = { append = "r" },
    refactor = "r",
    inline = "i",
    extract = "e",
    rewrite = "w",
  },
  source = "s",
})
