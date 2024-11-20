local quill = require("util.quill")

return quill({
  LEADER = "<leader>m",
  layout = {
    vertical = "v",
    horizontal = "h",
    float = "f",
    tabbed = "<tab>",
  },
  utiliterm = {
    broot = "t",
    weechat = "w",
    sysz = "s",
    btop = "b",
    gitui = "g",
  },
})
