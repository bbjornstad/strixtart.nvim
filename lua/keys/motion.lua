local quill = require("util.quill")

return quill({
  LEADER = "g",
  precognition = {
    LEADER = { append = "e" },
    toggle = "t",
    peek = "e",
  },
  grapple = {
    LEADER = { append = "p" },
    toggle = "t",
    tag = "g",
    toggle_tags = "p",
    untag = "u",
    select = "s",
    quickfix = "q",
    reset = "d",
    cycle = {
      backward = "C",
      forward = "c",
    },
    toggle_scopes = "z",
    toggle_loaded = "l",
    select_scope = "Z",
  },
  portal = {
    LEADER = { append = "o" },
    changelist = {
      forward = "c",
      backward = "C",
    },
    grapple = {
      forward = "g",
      backward = "G",
    },
    quickfix = {
      forward = "q",
      backward = "Q",
    },
    jumplist = {
      forward = "j",
      backward = "j",
    },
  },
  harpoon = {
    LEADER = { append = "H" },
    nav = { next = "n", previous = "p", file = "f" },
    add_file = "h",
    quick_menu = "m",
    term = { to = "t", send = "s", menu = "M" },
  },
})
