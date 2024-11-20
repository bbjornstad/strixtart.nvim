local quill = require("util.quill")

return quill({
  LEADER = "<leader>x",
  diagnostics = {
    workspace = "X",
    buffer = "x",
    cascade = {
      buffer = "a",
      workspace = "A",
    },
  },
  lsp = {
    workspace = "L",
    buffer = "l",
    declarations = {
      workspace = "A",
      buffer = "a",
    },
    definitions = {
      workspace = "d",
      buffer = "D",
    },
    references = {
      workspace = "R",
      buffer = "r",
    },
    implementations = {
      workspace = "I",
      buffer = "i",
    },
    type_definitions = {
      workspace = "T",
      buffer = "t",
    },
    document_symbols = {
      workspace = "Y",
      buffer = "y",
    },
  },
  quickfix = {
    workspace = "Q",
    buffer = "q",
  },
  loclist = {
    workspace = "C",
    buffer = "c",
  },
  telescope = {
    workspace = "Z",
    buffer = "z",
  },
  fzf = {
    workspace = "F",
    buffer = "f",
  },
})
