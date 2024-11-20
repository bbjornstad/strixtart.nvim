local lang = require("util.lang")

local yaml = lang.language("yaml", { "yaml", "yml" }, { mason = true })

return {
  yaml:server("yamlls"):linter("yamllint"):formatter("yamlfmt"):tolazy(),
}
