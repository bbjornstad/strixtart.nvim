local key_cmp = require("keys.completion")

return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        [key_cmp.jump.j] = { "select_next", "fallback" },
        [key_cmp.jump.k] = { "select_prev", "fallback" },
        [key_cmp.jump.reverse.j] = { "select_prev", "fallback" },
        [key_cmp.jump.reverse.k] = { "select_next", "fallback" },
        [key_cmp.jump.next] = { "snippet_forward", "fallback" },
        [key_cmp.jump.previous] = { "snippet_backward", "fallback" },
        [key_cmp.jump.reverse.next] = { "snippet_backward", "fallback" },
        [key_cmp.jump.reverse.previous] = { "snippet_forward", "fallback" },
        [key_cmp.jump.up] = { "select_prev", "fallback" },
        [key_cmp.jump.down] = { "select_next", "fallback" },
        [key_cmp.jump.reverse.up] = { "select_next", "fallback" },
        [key_cmp.jump.reverse.up] = { "select_prev", "fallback" },
        [key_cmp.docs.forward] = { "scroll_documentation_down", "fallback" },
        [key_cmp.docs.backward] = { "scroll_documentation_up", "fallback" },
        [key_cmp.trigger] = {
          "show",
          "show_documentation",
          "hide_documentation",
          "fallback",
        },
        ["<C-y>"] = { "select_and_accept", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<CR>"] = { "confirm", "fallback" },
        ["<S-CR>"] = { "confirm", "fallback" },
        ["<C-S-CR>"] = { "hide", "fallback" },
      },
    },
  },
}
