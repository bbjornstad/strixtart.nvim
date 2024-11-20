local M = {}

local function focus_direction_mapper(dir_indicated)
  local has = vim.tbl_contains
  if has({ "j", "<Down>" }, dir_indicated) then
    return "j"
  elseif has({ "k", "<Up>" }, dir_indicated) then
    return "k"
  elseif has({ "h", "<Left>" }, dir_indicated) then
    return "h"
  elseif has({ "l", "<Right>" }, dir_indicated) then
    return "l"
  end
end

function M.focus_split_helper()
  local dir_indicated = vim.v.char
  require('util.lazy').info(vim.inspect(dir_indicated))
  require('util.lazy').info(type(dir_indicated))
  dir_indicated = focus_direction_mapper(dir_indicated)
  return function()
    require("focus").split_command(dir_indicated)
  end
end

return M
