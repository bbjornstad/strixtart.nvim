local quill = require("util.quill")

local leader_code = "<leader>c"

return quill({
  LEADER = "",
  hover = "K",
  hover_select = "<C-S-k>",
  go = {
    LEADER = { append = "g" },
    definition = "d",
    declaration = "D",
    implementation = "i",
    type_definition = "y",
    references = "r",
    signature_help = "K",
    glance = {
      LEADER = { append = "l" },
      definition = "d",
      declaration = "D",
      implementation = "i",
      type_definition = "y",
      references = "r",
    },
    line_items = {
      LEADER = { append = "l" },
      float = "l",
    },
  },
  diagnostic = {
    LEADER = { append = leader_code },
    workspace = "D",
    buffer = "d",
  },
  rename = leader_code .. "r",
  format = {
    LEADER = { append = leader_code .. "f" },
    zero = "F",
    default = "f",
    pick = "p",
    list = "l",
    info = "i",
  },
  lint = {
    LEADER = { append = leader_code .. "l" },
    lint = "l",
    clear = "c",
    ignore = "i",
    lookup = "k",
  },
  log = leader_code .. "g",
  code = {
    LEADER = { append = leader_code },
    toggle = {
      LEADER = { append = "t" },
      server = "s",
      nullls = "n",
    },
    action = "a",
    output_panel = "p",
    mason = "m",
    venv = "v",
    cmp = "x",
  },
  info = leader_code .. "i",
  workspace = {
    LEADER = { append = "<leader>W" },
    add = "a",
    list = "l",
    remove = "r",
  },
  calls = {
    LEADER = { append = leader_code },
    incoming = "n",
    outgoing = "o",
  },
  clh = {
    LEADER = { append = leader_code .. "h" },
    regrun = "h",
  },
})
