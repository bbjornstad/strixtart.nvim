local quill = require("util.quill")

return quill({
  LEADER = "<leader>t",
  run = {
    LEADER = { append = "r" },
    nearest = "r",
    file = "R",
    dap = "d",
    stop = "s",
    attach = "a",
  },
})
