local quill = require("util.quill")

return quill({
  LEADER = "",
  todo = {
    LEADER = { append = "t" },
  },
  diagtrouble = {
    LEADER = { append = "x" },
    error = {
      LEADER = { append = "e" },
    },
    warning = {
      LEADER = { append = "w" },
    },
    info = {
      LEADER = { append = "i" },
    },
    hint = {
      LEADER = { append = "h" },
    },
    general = {
      LEADER = { append = "x" },
    },
  },
})
