local quill = require("util.quill")

return quill({
  LEADER = "<leader>d",
  neogen = {
    generate = "d",
    class = "c",
    fn = "f",
    type = "t",
  },
  devdocs = {
    buffer = "B",
    buffer_float = "b",
    fetch = "h",
    install = "i",
    open = "O",
    open_float = "o",
    uninstall = "u",
  },
  treedocs = {
    LEADER = { append = "e" },
    node_at_cusor = "d",
    all_in_range = "e",
  },
  auto_pandoc = { run = "p" },
})
