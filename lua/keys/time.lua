local quill = require("util.quill")

return quill({
  LEADER = "<localleader>",
  weather = "W",
  stand = {
    LEADER = { append = "s" },
    now = "n",
    when = "s",
    every = "e",
    disable = "d",
    enable = "o",
  },
  pomodoro = {
    LEADER = { append = "p" },
    start = "s",
    stop = "q",
    status = "u",
  },
  unfog = "u",
  do_ = "d",
  conduct = "c",
  pulse = {
    LEADER = { append = "p" },
    new_custom = "n",
    new_disabled_custom = "N",
    enable_standard = "t",
    disable_standard = "t",
    pick = "p",
  },
  neorg = {
    search_headings = "h",
    journal = {
      LEADER = { append = "j" },
      daily = "d",
      yesterday = "y",
      tomorrow = "t",
      toc = "c",
      templates = "p",
      custom = "j",
    },
    notes = {
      LEADER = { append = "n" },
      new = "n",
      capture = {
        LEADER = { append = "c" },
        todo = {
          LEADER = { append = "t" },
          high = "h",
          medium = "m",
          low = "l",
          recurring = "r",
        },
      },
    },
    linkable = {
      LEADER = { append = "l" },
      find = "f",
      insert = "i",
      file = "e",
    },
    metagen = {
      LEADER = { append = "m" },
      inject = "i",
      update = "u",
    },
    workspace = {
      LEADER = { append = "w" },
      default = "d",
      switch = "w",
    },
    dt = {
      LEADER = { append = "d" },
      insert = "t",
    },
    export = {
      LEADER = { append = "x" },
      to_file = {
        md = "m",
        txt = "t",
      },
    },
  },
  org = {
    task = {
      LEADER = { append = "t" },
      standard = "s",
      undated = "u",
      discrete = "d",
      full = "f",
    },
    event = {
      LEADER = { append = "e" },
      _until = "u",
      single = "s",
      range = "r",
    },
  },
  dates = {
    LEADER = { append = "d" },
    get = { prefix = "p" },
    relative = {
      LEADER = { append = "r" },
      toggle = "r",
      attach = "a",
      detach = "d",
    },
  },
  oogway = {
    LEADER = { append = "o" },
    sense = "d",
    wisdom = "w",
    inspire = "i",
    all_wisdom = "W",
    all_inspiration = "I",
  },
})
