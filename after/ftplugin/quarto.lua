local omapx = require("util.keys").dmapx({ default = { remap = false } })
local function omapn(lhs, rhs, opts)
  return omapx("n", lhs, rhs, opts)
end

local comps = require("env.status.component")

local M = {}

omapn("gd", function()
  require("otter").ask_definition()
end, { desc = { family = "repl", group = "otter", action = "definition" } })
omapn("gK", function()
  require("otter").ask_hover()
end, { desc = { family = "repl", group = "otter", action = "hover", silent = true } })

return M
