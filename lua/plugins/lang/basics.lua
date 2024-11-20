local lang = require("util.lang")

local basics = lang.language("_", "*", {
  mason = true,
})

local spec = { basics:server("basics_ls"):tolazy() }

return spec
