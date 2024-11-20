local M = {}

local OPER = {
  insert = function(target, entity, ix)
    vim.print(
      "in insert...",
      "Index: ",
      ix,
      "Entity: ",
      entity,
      "Target: ",
      target
    )
    if not ix then
      require("util.newts").error(
        [[
        Index specification is required for insert!
        Given: %s
        ]],
        ix
      )
      return
    end
    target[ix] = target[ix] or {}
    table.insert(target[ix], entity)
  end,
  send = function(target, entity, ix)
    vim.print(
      "in insert...",
      "Index: ",
      ix,
      "Entity: ",
      entity,
      "Target: ",
      target
    )
    if not ix then
      require("util.newts").error(
        [[
            Index specification is required for send!
            Given: %s
            ]],
        ix
      )
      return
    end
    target[ix] = entity
  end,
  mod = function(target, entity, ix)
    vim.print(
      "in insert...",
      "Index: ",
      ix,
      "Entity: ",
      entity,
      "Target: ",
      target
    )
    if not ix then
      require("util.newts").error(
        [[
            Index specification is required for mod!
            -- Given: %s
            ]],
        ix
      )
      return
    end
    -- Ensure parent exists
    target[ix] = target[ix] or {}
    -- Apply modification
    entity(target[ix])
  end,
}

local function resolve_index(tool, probable)
  local ix
  if not probable then
    return false
  end

  vim.print("resolving index: ", probable, "from tool: ", tool)

  if type(probable) == "string" then
    ix = vim.split(probable, [[.]], { plain = true })
  elseif type(probable) == "table" and not vim.islist(probable) then
    ix = vim.deepcopy(probable)
  end

  if type(ix) == "table" then
    return vim.tbl_get(tool, unpack(ix))
  end

  return tool[ix]
end

local function param(opts, operation, ...)
  local callbacks = { ... }

  ---@type string | string[] | boolean
  local source = opts.from or false
  if source then
    if type(source) == "string" then
      source = vim.split(source, [[.]], { plain = true })
    elseif type(source) == "table" then
      source = vim.deepcopy(source)
    end
  else
    source = { "name" }
  end

  ---@cast source string[]

  local twrap = opts.wrap or false

  local required = opts.required or false

  return function(tool, target)
    local ix = resolve_index(tool, opts.ix)
    local value = vim.tbl_get(tool, unpack(source)) or false
    if not value then
      if required then
        require("util.newts").warn(
          "Failed to get %s from tool %s",
          table.concat(source, "."),
          tool
        )
        return
      else
        return
      end
    end

    if twrap == "box" then
      value = { value }
    end

    local final_ix = ix and vim.tbl_get(tool, unpack(ix)) or false
    if type(final_ix) ~= "table" then
      final_ix = { final_ix }
    end

    vim.print("Index: ", final_ix, "Value: ", value, "Target: ", target)

    vim.iter(final_ix):each(function(index)
      operation(target, value, index)
    end)
  end
end

local function fixwrap(fn)
  return function(tool, target)
    local value = fn(tool, target)
  end
end

function M.insert(opts)
  local op = param(opts, OPER.insert)
  return op
end

function M.send(opts)
  local op = param(opts, OPER.send)
  return op
end

function M.mod(opts)
  local op = param(opts, OPER.mod)
  return op
end

function M.nor(...)
  local opers = { ... }

  return function(tool, target)
    for _, oper in ipairs(opers) do
      local res = oper(tool, target)
      if res ~= nil then
        return res
      end
    end
  end
end

function M.p(...)
  local opers = { ... }

  return function(tool, target)
    local successes = {}
    local failures = {}
    for i, oper in ipairs(opers) do
      local ok, res = pcall(oper, tool, target)
      if ok then
        successes[i] = res
      else
        failures[i] = res
      end
    end

    return successes, failures
  end
end

return M
