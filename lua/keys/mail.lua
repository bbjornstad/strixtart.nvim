local quill = require("util.quill")

local leader_mail = "<leader>M"

return quill({
  LEADER = "",
  himalaya = leader_mail,
  action = {
    change_folder = "gf",
    page = {
      previous = "[p",
      next = "]p",
    },
    read = "<CR>",
    compose = "C",
    reply = "rr",
    reply_all = "ra",
    forward = "f",
    download_attachments = "ga",
    locate = {
      copy = "gc",
      move = "gF",
      delete = "gd",
    },
    add_attachment = "gA",
  },
})
