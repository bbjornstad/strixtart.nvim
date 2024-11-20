local quill = require("util.quill")

return quill({
  LEADER = ";",
  supermaven = {
    LEADER = { append = "s" },
    start = "t",
    stop = "d",
    restart = "r",
    toggle = "s",
    is_running = "h",
    use_free_version = "F",
    use_pro = "P",
    logout = "O",
    show_log = "g",
    clear_log = "G",
  },
  codecompanion = {
    LEADER = { append = "m" },
    inline = "N",
    chat = "c",
    toggle = "n",
    actions = "a",
  },
  avante = {
    LEADER = { append = "a" },
    diff = {},
    suggestion = {},
    jump = {},
    submit = {},
    ask = "a",
    edit = "e",
    refresh = "r",
    toggle = {
      LEADER = { append = "t" },
      default = "t",
      debug = "d",
      hint = "h",
      suggestion = "s",
    },
    sidebar = {
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
    },
  },
})
