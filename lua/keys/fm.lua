local quill = require("util.quill")

return quill({
  LEADER = "<leader>f",
  fs = {
    find_files = "f",
    recent_files = "r",
    new = "e",
  },
  oil = {
    LEADER = { append = "o" },
    open_float = "o",
    open = "O",
    split = "s",
  },
  nnn = {
    LEADER = { append = "n" },
    explorer = "E",
    explorer_here = "e",
    picker = "p",
  },
  broot = {
    LEADER = { append = "t" },
    working_dir = "t",
    current_dir = "c",
    git_root = "g",
  },
  bolt = {
    LEADER = { append = "l" },
    open_root = "o",
    open_cwd = "O",
  },
  memento = {
    LEADER = { append = "m" },
    toggle = "m",
    clear = "c",
  },
  attempt = {
    LEADER = { append = "s" },
    new_select = "n",
    new_input_ext = "i",
    run = "r",
    delete = "d",
    rename = "c",
    open_select = "s",
  },
  arena = {
    LEADER = { append = "a" },
    toggle = "a",
    open = "o",
    close = "c",
  },
  tfm = {
    LEADER = { append = "i" },
    open = "i",
    vsplit = "v",
    hsplit = "h",
    tab = "<tab>",
    change_manager = "m",
  },
  yazi = {
    LEADER = { append = "z" },
    global_working_dir = "g",
    working_dir = "Z",
    current_file_dir = "c",
    select_dir = "z",
  },
})
