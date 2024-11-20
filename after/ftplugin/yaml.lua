local quill = require("util.quill")

local key_yaml = quill({
  LEADER = "'",
  schema = "y",
})

vim.keymap.set("n", key_yaml.schema, function()
  require("yaml-companion").open_ui_select()
end, { desc = "code:| schema |=> yaml" })
