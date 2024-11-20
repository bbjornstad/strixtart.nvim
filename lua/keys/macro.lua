local quill = require("util.quill")

return quill({
  LEADER = "<leader>q",
  record = "q",
  play = "Q",
  switch = "s",
  edit = "e",
  yank = "y",
  addBreakPoint = "##.",
})
