local quill = require("util.quill")

return quill({
  LEADER = "<leader>v",
  visits = {
    label = {
      add = "a",
      remove = "r",
      select = "s",
      list = "l",
    },
    path = {
      add = "A",
      remove = "R",
      select = "S",
      list = "L",
    },
    branch = {
      LEADER = { append = "g" },
      add = "b",
      remove = "r",
    },
    register = "r",
  },
})
