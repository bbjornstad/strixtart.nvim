local quill = require("util.quill")

return quill({
  LEADER = "<leader>C",
  pick = "C",
  darken = "D",
  lighten = "L",
  greyscale = "G",
  list = "l",
  convert = {
    LEADER = { append = "V" },
    select = "V",
    hex = "X",
    hsl = "S",
    rgb = "R",
    rgba = "A",
    eightbit = "E",
    oklab = "L",
    okhsl = "S",
    oklch = "H",
  },
  inline_hl = {
    toggle = "c",
    detach = "d",
    attach = "a",
    reload = "r",
  },
  interactive = "I",
  pineapple = "P",
  shades = {
    LEADER = { append = "S" },
    open = "S",
    save = "c",
  },
  huefy = {
    LEADER = { append = "H" },
    open = "H",
    save = "c",
  },
  util = {
    LEADER = { append = "U" },
    lighten = "L",
    darken = "D"
  }
})
