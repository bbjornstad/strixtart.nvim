return {
  {
    "lukas-reineke/headlines.nvim",
    enabled = false,
    ft = { "org", "norg", "markdown", "md", "rmd", "quarto" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      vim.api.nvim_set_hl(0, "Headline", { link = "NormalFloat" })
    end,
    opts = {
      bullets = {},
      markdown = {
        headline_highlights = { "Headline" },
      },
      rmd = {
        headline_highlights = { "Headline" },
      },
      norg = {
        headline_highlights = { "Headline" },
      },
      org = {
        headline_highlights = { "Headline" },
      },
    },
  },
}
