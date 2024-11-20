local quill = require("util.quill")

return quill({
  LEADER = "<leader>v",
  aerial = {
    LEADER = { append = "a" },
    toggle = "a",
    open = "o",
    close = "q",
    force = {
      toggle = "A",
      open = "O",
      close = "Q",
    },
  },
  symbols_outline = {
    toggle = "v",
    open = "o",
    close = "q",
  },
  undotree = {
    LEADER = { append = "u" },
    toggle = "t",
    open = "o",
    close = "q",
  },
  infowindow = "i",
  keyseer = "k",
  lens = {
    LEADER = { append = "e" },
    toggle = "e",
    on = "o",
    off = "q",
  },
  context = {
    LEADER = { append = "t" },
    toggle = "t",
    debug = "d",
    biscuits = "b",
  },
  edgy = {
    LEADER = { append = "e" },
    toggle = "e",
    select = "s",
  },
  diagnostic = {
    LEADER = { append = "d" },
    open_float = "d",
    diaglist = {
      workspace = "Q",
      buffer = "q",
    },
    lsp_lines = { toggle = "l" },
    error_lens = { toggle = "e" },
  },
  securitree = { toggle = "S" },
  treesitter_nav = {
    LEADER = { append = "t" },
    definition = "d",
    next_usage = "n",
    previous_usage = "p",
    list_definitions = "D",
    list_definitions_toc = "0",
  },
  key_analyzer = 'K',
})
