return {
  {
    "folke/lazy.nvim",
    init = function()
      local fixer = require("util.autocmd").buffixcmdr("LazyNvimBufferFix", true)
      fixer({ "FileType" }, { pattern = "lazy" })
    end,
  },
}
