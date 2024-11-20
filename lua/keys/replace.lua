local quill = require("util.quill")

return quill({
  LEADER = "<leader>r",
  muren = {
    LEADER = { append = "m" },
    toggle = "m",
    open = "o",
    close = "q",
    fresh = "f",
    unique = "u",
  },
  inc_rename = "i",
  structural = "s",
  replacer = "q",
  treesitter = "e",
})
