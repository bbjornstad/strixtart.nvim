---@module "cmp.mappings" main mappings for nvim-cmp, defining standard behavior
---for default popup completion menus and ideally a component to allow for the
---creation of cmp-submenus which hold a subset of sources or features.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@diagnostic disable: different-requires, undefined-field, missing-fields

local kenv_cmp = require("keys.completion")

local function snippet_advance(direction, opts)
  local cmp = require("cmp")
  local zeroact = require("lsp-zero").cmp_action()
  direction = direction or "forward"
  local dirvec = direction == "forward" and 1 or -1
  local mode = opts.mode or false
  return function(fallback)
    -- first check if a snippet is active and perform the jump if so
    if vim.snippet.active({ direction = dirvec }) then
      if direction == "backward" then
        zeroact.vim_snippet_jump_backward()
        return
      end
      zeroact.vim_snippet_jump_forward()
      return
    end

    -- otherwise, check if a cmp entry is active and perform the completion
    local behavior = opts.behavior or cmp.SelectBehavior.Select
    if cmp.visible() and cmp.get_active_entry() then
      if direction == "backward" then
        cmp.select_prev_item({ behavior = behavior })
        return
      end
      cmp.select_next_item({ behavior = behavior })
      return
    end

    -- no suitable jump to perform, so we just execute the target fallback.
    fallback()
  end
end

local function snipadvance(direction, opts)
  opts = opts or {}
  direction = direction or "forward"
  direction = type(direction) ~= "table" and { direction } or direction
  ---@type string | string[] | boolean
  local modes = opts.modes or { "i", "s" }
  modes = vim.islist(modes) and require("util.table").invert(modes) or modes

  local res = require("util.fn").smap(function(mode, _)
    return snippet_advance(direction, { mode = mode })
  end, modes)

  return res
end

return {
  {
    "nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
    opts = function(_, opts)
      local cmp = require("cmp")
      local has = require("util.lazy").has
      local cmp_action = require("lsp-zero").cmp_action()
      opts.mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({
                select = false,
                behavior = cmp.ConfirmBehavior.Replace,
              })
            else
              fallback()
            end
          end,
          c = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end,
          s = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({
                select = false,
                behavior = cmp.ConfirmBehavior.Replace,
              })
            else
              fallback()
            end
          end,
        }),
        ["<S-CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({
                select = false,
                behavior = cmp.ConfirmBehavior.Insert,
              })
              fallback()
            end
          end,
          c = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end,
          s = function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
              cmp.confirm({
                select = false,
                behavior = cmp.ConfirmBehavior.Insert,
              })
            else
              fallback()
            end
          end,
        }),
        ["<C-S-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        -- ["<TAB>"] = cmp_action.luasnip_supertab(),
        [kenv_cmp.jump.j] = cmp.mapping.select_next_item({
          select = cmp.SelectBehavior.Select,
          count = 1,
        }),
        [kenv_cmp.jump.next] = snipadvance("forward"),
        [kenv_cmp.jump.down] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Select,
          count = 4,
        }),
        [kenv_cmp.jump.k] = cmp.mapping.select_prev_item({
          select = cmp.SelectBehavior.Select,
          count = 1,
        }),
        [kenv_cmp.jump.previous] = snipadvance("backward"),
        [kenv_cmp.jump.up] = cmp.mapping.select_prev_item({
          select = cmp.SelectBehavior.Select,
          count = 4,
        }),
        [kenv_cmp.jump.reverse.next] = snipadvance("backward"),
        [kenv_cmp.jump.reverse.previous] = snipadvance("forward"),
        [kenv_cmp.jump.reverse.j] = cmp.mapping.select_prev_item({
          behavior = cmp.SelectBehavior.Select,
          count = 1,
        }),
        [kenv_cmp.jump.reverse.k] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Select,
          count = 1,
        }),
        [kenv_cmp.jump.reverse.up] = cmp.mapping.select_next_item({
          selet = cmp.SelectBehavior.Select,
          count = 4,
        }),
        [kenv_cmp.jump.reverse.down] = cmp.mapping.select_prev_item({
          select = cmp.SelectBehavior.Select,
          count = 4,
        }),

        [kenv_cmp.docs.backward] = cmp.mapping.scroll_docs(-4),
        [kenv_cmp.docs.forward] = cmp.mapping.scroll_docs(4),
        [kenv_cmp.external.complete_common_string] = cmp.mapping.complete_common_string(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-c>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = cmp.SelectBehavior.Insert,
        }),
        [kenv_cmp.trigger] = cmp.mapping.complete(),
        -- we are going to make a mapping that will allow us to access focused
        -- groups of the completion menu with certain keystrokes. In particular, we
        -- have that Ctrl+Space should be the way that we bring up a completion
        -- menu. If we remap this so that it includes a submenu, we can have
        -- individual keymappings to access, say for instance, the fonts completion
        -- options specifically (C+o+f).
        [kenv_cmp.submenus.ai.libre] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "codeium" },
                  { name = "cmp_tabnine" },
                  { name = "cmp_ai" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.git] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "git" },
                  { name = "conventionalcommits" },
                  { name = "commit" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.shell] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "zsh" },
                  { name = "fish" },
                }, {
                  { name = "buffer" },
                  { name = "rg" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.glyph] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "fonts", option = { space_filter = "-" } },
                  { name = "nerdfont" },
                  { name = "emoji" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.lsp] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "nvim_lsp" },
                  { name = "luasnip" },
                  { name = "dap" },
                  { name = "diag-codes" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.location] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "git" },
                  { name = "path" },
                  { name = "cmdline" },
                  { name = "look" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.ai.langfull] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "copilot" },
                  { name = "codeium" },
                  { name = "cmp_tabnine" },
                  { name = "cmp_ai" },
                  { name = "cody" },
                  { name = "nvim_lsp" },
                }),
              },
            })
          then
            fallback()
          end
        end,
      }, opts.mapping or {})
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local wk = require("which-key")
      wk.add({
        {
          mode = { "i", "s" },
          { "<C-Space>", group = "cmp.submenu" },
          { "<C-Space><C-.>", desc = "local session" },
          { "<C-Space><C-Space>", desc = "all" },
          { "<C-Space><C-a>", desc = "AI (libre)" },
          { "<C-Space><C-g>", desc = "git" },
          { "<C-Space><C-l>", desc = "LSP" },
          { "<C-Space><C-n>", desc = "language (full)" },
          { "<C-Space><C-s>", desc = "shell" },
          { "<C-Space><C-y>", desc = "glyph" },
        },
      })
    end,
  },
}
