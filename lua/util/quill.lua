local M = {}

local newts = require('util.newts')
local smap = require("util.fn").smap

local F = {}

M.LEADER_IDX = "LEADER"

---@alias ixKeymap string

---@alias LeaderPrefix string

---@alias BindSpecifier string

---@alias KeymapComponent
---| LeaderPrefix
---| BindSpecifier

---@alias Keymap
---| BindSpecifier
---| SemanticKeymaps

---@class LeaderConfig
---@field override? LeaderPrefix
---@field clear? boolean
---@field append? LeaderPrefix
---@field prepend? LeaderPrefix
---@field eval? fun(leader: Leader): LeaderPrefix

---@alias Leader
---| LeaderConfig
---| LeaderPrefix

---@class SemanticKeymaps: { [ixKeymap]: Keymap, LEADER: Leader }
function M.quill(keymaps, gropts)
  gropts = gropts or {}

  local leader_expanded = F.make_leaders(keymaps, gropts)
  local final_maps = F.make_maps(leader_expanded, gropts)

  return final_maps
end

--- constructs the LEADER values for a given keymap table without touching any
--- of the subsequent keymaps. This allows us to process all the LEADER values
--- before we start to construct the final maps.
---@param keymaps SemanticKeymaps
---@param gropts { silent: boolean? }?
function F.make_leaders(keymaps, gropts, current_leader)
  current_leader = current_leader or ""
  local f = {}

  function f.process(leader_val, current)
    if type(leader_val) == 'table' then
      local new_leader = current
      if leader_val.clear then
        new_leader = ""
      end

      if leader_val.setdirect then
        new_leader = leader_val.setdirect
      end

      local prepend = leader_val.prepend or ""
      local append = leader_val.append or ""

      new_leader = prepend .. new_leader .. append

      if leader_val.eval then
        new_leader = leader_val.eval(new_leader)
      end

      return new_leader
    else
      return leader_val
    end
  end

  function f.inner(val, leader)
    if type(val) ~= 'table' then
      return val
    end

    local result = {}
    local new_leader = leader

    if val[M.LEADER_IDX] then
      new_leader = f.process(val[M.LEADER_IDX], leader)
      result[M.LEADER_IDX] = new_leader
    end

    for k, v in pairs(val) do
      if k ~= M.LEADER_IDX then
        result[k] = f.inner(v, new_leader)
      end
    end

    return result
  end

  local res = f.inner(keymaps, current_leader)
  return res
end

function F.make_maps(unexpanded, gropts)
  local function inner(tbl, current_leader)
    local res = {}
    -- we don't want to process any LEADER items, we only use those to
    -- construct keymaps
    for k, v in pairs(tbl) do
      if k == M.LEADER_IDX then
        -- skip
      elseif type(v) == 'table' then
        res[k] = inner(v, tbl[M.LEADER_IDX] or current_leader)
      else
        res[k] = (tbl[M.LEADER_IDX] or current_leader) .. v
      end
    end
    return res
  end
  local res = inner(unexpanded, "")
  return res
end

setmetatable(M, {
  __call = function(t, ...)
    return t.quill(...)
  end
})

return M
