local M = {}
local comps = require('env.status.component')
local slacker = require("util.status").slackline({})
local inclinate = require("util.status").inclinate

function M.colormapper(adjuster)
  local default = require('env.color').default_statusline_palette
  if adjuster ~= nil then
    return adjuster(default)
  end
  return default
end

M.statusline = slacker({
  comps.mode,
  comps.git,
  -- comps.typing_speed,
  comps.keystrokes,
  comps.configpulse,
  comps.align,
  comps.lsp,
  comps.file,
  comps.align,
  comps.labe,
  -- comps.weather,
  comps.localtime,
})

M.winbar = slacker({
  comps.breadcrumbs,
  comps.align,
  -- comps.music,
  comps.align,
  comps.diag.workspace,
})

M.tabline = slacker({
  comps.modicon,
  comps.tabpages,
  comps.bufline,
  comps.align,
  comps.timers,
  comps.ram,
  comps.recording,
  comps.workdir,
})

M.incline = function(props)
  local compinc = require('env.status.incline')
  local res = vim.tbl_filter(function(it)
    return it ~= nil
        and it ~= ""
        and (type(it) == "table" and vim.islist(it) or it)
      or false
  end, {
    compinc.fileinfo(props, { formatter = "╒╡ 󰧮 %s %s ╞╕ " }),
    compinc.searchcount(props, {
      icon = "󱈅",
      separator = " ",
      surround = { left = "⌈", right = "⌉" },
    }),
    compinc.selectioncount(props, {
      icon = "󱊄",
      separator = " ",
      surround = { left = "⌈", right = "⌉" },
    }),
    compinc.match_local_hl(props, {
      icon = "󰾹",
      separator = " ",
      surround = { left = "⌈", right = "⌉" },
    }),
    compinc.wrap_mode(props, {
      icon = "󰖶",
      separator = " ",
      surround = { left = "⌈", right = "⌉" },
    }),
    compinc.bufispinned(props, {
      icon = "󱧐",
      separator = " ",
      surround = { left = "⌈", right = " ⌉" },
    }),
    { {
      "",
      guifg = "blue",
    } },
  })
  return res
end

return M
