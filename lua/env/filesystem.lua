local M = {}
M.__index = M

M.ft_ignore_list = {
  "oil",
  "Outline",
  "dashboard",
  "fzf",
  "trouble",
  "toggleterm",
  "outline",
  "qf",
  "TelescopePrompt",
  "Telescope",
  "tsplayground",
  "spectre_panel",
  "undotree",
  "undotreeDiff",
  "neo-tree",
  "Lazy",
  "dropbar_menu",
  "noice",
  "nnn",
  "prompt",
  "broot",
  "gundo",
  "NvimTree",
  "spaceport",
  "alpha",
}

M.oil = {
  init_columns = "succinct",
  columns = {
    extended = {
      "icon",
      "type",
      "permissions",
      "birthtime",
      "atime",
      "mtime",
      "ctime",
      "size",
    },
    succinct = {
      "icon",
      "type",
      "ctime",
      "size",
    },
  },
}


return M
