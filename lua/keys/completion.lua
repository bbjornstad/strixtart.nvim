local quill = require("util.quill")

local leader_code = "<leader>c"

return quill({
  LEADER = "",
  trigger = "<C-Space><C-Space>",
  toggle = {
    LEADER = { append = leader_code .. "x" },
    enabled = "e",
    autocompletion = "c",
  },
  external = {
    LEADER = { append = "<C-x>" },
    complete_common_string = "<C-s>",
    complete_fuzzy_path = "<C-f>",
    complete_fuzzy_directory = "<C-d>",
  },
  submenus = {
    LEADER = { append = "<C-Space>" },
    ai = {
      libre = "<C-a>",
      langfull = "<C-:>",
    },
    git = "<C-g>",
    shell = "<C-s>",
    glyph = "<C-y>",
    lsp = "<C-l>",
    location = "<C-.>",
    snippet = "<C-s>",
    prose = "<C-p>",
    docs = "<C-d>",
  },
  docs = {
    forward = "<C-f>",
    backward = "<C-b>",
  },
  jump = {
    next = "<C-n>",
    previous = "<C-p>",
    up = "<C-u>",
    down = "<C-d>",
    j = "<C-j>",
    k = "<C-k>",
    reverse = {
      next = "<C-S-n>",
      j = "<C-S-j>",
      previous = "<C-S-p>",
      k = "<C-S-k>",
      up = "<C-S-u>",
      down = "<C-S-d>",
    },
  },
  confirm = "<C-y>",
  snippet = {
    LEADER = { append = "<C-s>" },
    edit = "<C-e>",
    cmp = "<C-s>",
    select_choice = "<C-i>",
  },
})
