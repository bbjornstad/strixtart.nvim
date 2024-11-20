local quill = require("util.quill")

return quill({
  LEADER = "<leader>w",
  ventana = {
    transpose = "t",
    shift = "s",
    linear_shift = "S",
  },
  goto_led = {
    left = "<Left>",
    right = "<Right>",
    up = "<Up>",
    down = "<Down>",
  },
  focus = {
    maximize = "z",
    split = {
      cycle = "c",
      direction = "s",
    },
  },
  accordian = "a",
  windows = {
    maximize = "z",
    maximize_horizontal = "_",
    maximize_vertical = "|",
    equalize = "=",
  },
})
