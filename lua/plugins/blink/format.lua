return {
  {
    "saghen/blink.cmp",
    opts = {
      kind_icons = require("env.ui").icons.kinds,
      highlight = {
        ns = vim.api.nvim_create_namespace("blink_cmp"),
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
      },
      windows = {
        autocomplete = {
          min_width = 24,
          max_height = 32,
          border = require("env.ui").borders.main,
          winblend = 32,
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          -- keep the cursor X lines away from the top/bottom of the window
          scrolloff = 4,
          -- note that the gutter will be disabled when border ~= 'none'
          scrollbar = true,
          -- which directions to show the window,
          -- falling back to the next direction when there's not enough space
          direction_priority = { "s", "n" },
          -- Controls whether the completion window will automatically show when typing
          auto_show = true,
          -- Controls how the completion items are selected
          -- 'preselect' will automatically select the first item in the completion list
          -- 'manual' will not select any item by default
          -- 'auto_insert' will not select any item by default, and insert the completion items automatically when selecting them
          selection = "auto_insert",
          -- Controls how the completion items are rendered on the popup window
          draw = {
            align_to_component = "label", -- or 'none' to disable
            -- Left and right padding, optionally { left, right } for different padding on each side
            padding = 2,
            -- Gap between columns
            gap = 2,
            -- Components to render, grouped by column
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
            },
            -- Definitions for possible components to render. Each component defines:
            --   ellipsis: whether to add an ellipsis when truncating the text
            --   width: control the min, max and fill behavior of the component
            --   text function: will be called for each item
            --   highlight function: will be called only when the line appears on screen
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  return ctx.kind_icon .. " "
                end,
                highlight = function(ctx)
                  return "BlinkCmpKind" .. ctx.kind
                end,
              },

              kind = {
                ellipsis = false,
                text = function(ctx)
                  return ctx.kind .. " "
                end,
                highlight = function(ctx)
                  return "BlinkCmpKind" .. ctx.kind
                end,
              },

              label = {
                width = { fill = true, max = 72 },
                text = function(ctx)
                  return ctx.label .. (ctx.label_detail or "")
                end,
                highlight = function(ctx)
                  -- label and label details
                  local highlights = {
                    {
                      0,
                      #ctx.label,
                      group = ctx.deprecated and "BlinkCmpLabelDeprecated"
                        or "BlinkCmpLabel",
                    },
                  }
                  if ctx.label_detail then
                    table.insert(highlights, {
                      #ctx.label,
                      #ctx.label + #ctx.label_detail,
                      group = "BlinkCmpLabelDetail",
                    })
                  end

                  -- characters matched on the label by the fuzzy matcher
                  if ctx.label_matched_indices ~= nil then
                    for _, idx in ipairs(ctx.label_matched_indices) do
                      table.insert(
                        highlights,
                        { idx, idx + 1, group = "BlinkCmpLabelMatch" }
                      )
                    end
                  end

                  return highlights
                end,
              },

              label_description = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.label_description or ""
                end,
                highlight = "BlinkCmpLabelDescription",
              },
            },
          },
          -- Controls the cycling behavior when reaching the beginning or end of the completion list.
          cycle = {
            -- When `true`, calling `select_next` at the *bottom* of the completion list will select the *first* completion item.
            from_bottom = true,
            -- When `true`, calling `select_prev` at the *top* of the completion list will select the *last* completion item.
            from_top = true,
          },
        },
        documentation = {
          min_width = 16,
          max_width = 72,
          max_height = 24,
          border = "padded",
          winblend = 20,
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          -- note that the gutter will be disabled when border ~= 'none'
          scrollbar = true,
          -- which directions to show the documentation window,
          -- for each of the possible autocomplete window directions,
          -- falling back to the next direction when there's not enough space
          direction_priority = {
            autocomplete_north = { "e", "w", "n", "s" },
            autocomplete_south = { "e", "w", "s", "n" },
          },
          -- Controls whether the documentation window will automatically show when selecting a completion item
          auto_show = true,
          auto_show_delay_ms = 2000,
          update_delay_ms = 50,
        },
        signature_help = {
          min_width = 2,
          max_width = 120,
          max_height = 16,
          border = "padded",
          winblend = 20,
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
          -- note that the gutter will be disabled when border ~= 'none'
          scrollbar = true,

          -- which directions to show the window,
          -- falling back to the next direction when there's not enough space
          direction_priority = { "n", "s" },
        },
        ghost_text = {
          enabled = true,
        },
      },
    },
  },
}
