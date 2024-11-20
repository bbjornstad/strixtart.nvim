local quill = require("util.quill")

local leader_build = "'"

return quill({
  LEADER = leader_build,
  executor = "e",
  overseer = {
    LEADER = { append = "o" },
    open = "o",
    close = "q",
    toggle = "v",
    task = { new = "n", list = "l" },
    bundle = {
      list = "b",
      load = "L",
      delete = "d",
    },
    run = {
      LEADER = { append = "r" },
      template = "r",
      action = "a",
    },
  },
  runner = {
    LEADER = { append = "r" },
    run = "r",
    autorun = { enable = "r", disable = "q" },
  },
  compiler = {
    LEADER = { append = "c" },
    open = "o",
    toggle = "c",
    close = "q",
  },
  rapid = leader_build,
  build = { LEADER = { append = "b" } },
  launch = {
    LEADER = { append = "l" },
    task = "t",
    ft_task = "T",
    config_show = "c",
    ft_config_show = "C",
    active = "a",
    debugger = "d",
    ft_debugger = "D",
    config_debug = "g",
    ft_config_debug = "G",
    config_edit = "e",
  },
})
