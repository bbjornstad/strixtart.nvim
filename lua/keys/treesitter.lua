local quill = require("util.quill")

return quill({
  LEADER = "",
  modules = {
    LEADER = { append = "gt" },
    textsubjects = {
      smart = "t",
      outer = "o",
      inner = "i",
      previous = "p",
    },
  },
})
