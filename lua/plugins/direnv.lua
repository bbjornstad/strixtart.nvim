return {
  {
    "direnv/direnv.vim",
    event = "VeryLazy",
    config = false,
  },
  {
    "ellisonleao/dotenv.nvim",
    opts = {
      enable_on_load = true,
      verbose = false,
    },
    event = "VimEnter",
    cmd = { "Dotenv", "DotenvGet" },
  },
}
