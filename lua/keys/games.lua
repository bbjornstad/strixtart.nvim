local quill = require("util.quill")

return quill({
  LEADER = "<leader><bar>",
  solitaire = {
    LEADER = { append = "s" },
    new = "n",
    next = "N",
  },
  tetris = "t",
  sudoku = "u",
  blackjack = "j",
  nvimesweeper = "w",
  killersheep = "k",
  speedtyper = "y",
  play2048 = "2",
  playtime = {
    LEADER = { append = "p" },
    select = "p",
  },
})
