local quill = require("util.quill")

return quill({
  LEADER = "<leader>p",
  new = "N",
  update = "u",
  delete = "d",
  list = "p",
  workspaces = {
    add = "n",
    remove = "x",
    add_dir = "a",
    remove_dir = "X",
    rename = "r",
    list = "l",
    list_dirs = "L",
    sync_dirs = "y",
    telescope = "z",
  },
})
