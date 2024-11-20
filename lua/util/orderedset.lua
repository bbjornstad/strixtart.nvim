---@class OrderedSet.Elements<K, E>: { [K]: E }
---@class OrderedSet.Set<K, E>: { [E]: K }

--- together, the two fields of the OrderedSet help keep track of the insertion
--- order of elements into this set-like table as well as enforces the
--- uniqueness aspect in order to be set-like at all.
---@class util.OrderedSet<K, E>
---@field set OrderedSet.Elements<`K`, `E`>
---@field elements OrderedSet.Set<`K`, `E`>
---
local OrderedSet = {}
OrderedSet.__index = OrderedSet

---@generic E
--- adds an element to the ordered set
---@param element E
function OrderedSet:add(element)
  if not self.set[element] then
    table.insert(self.elements, element)
    self.set[element] = #self.elements
  end
end

---@generic E
--- creates a new OrderedSet, using the given argument as the initial table
--- value underpinning the OrderedSet.
---@param initial { [integer]: E }? initial values that should be populated
---into the OrderedSet.
---@return util.OrderedSet<integer, E>
function OrderedSet.new(initial)
  initial = initial or {}
  local self = setmetatable({}, OrderedSet)
  self.set = {}
  self.elements = {}
  if initial and type(initial) == "table" then
    for _, element in ipairs(initial) do
      self:add(element)
    end
  end

  return self
end

---@generic E
--- check if an element exists in the set
---@param element E
---@return boolean
function OrderedSet:contains(element)
  return self.set[element] ~= nil
end

---@generic E
--- gets the index in the set of the item given as an argument
---@param element E element to get index of
---@return integer index
function OrderedSet:indexof(element)
  return self.set[element]
end

---@generic K, E
--- performs the set-theoretic intersection of an OrderedSet against another
--- OrderedSet
---@param otherSet util.OrderedSet<K, E>
---@return util.OrderedSet<K, E> intersected
function OrderedSet:intersect(otherSet)
  local intersection = self.new()
  for _, element in ipairs(self.elements) do
    if otherSet:contains(element) then
      intersection:add(element)
    end
  end
  return intersection
end

---@generic K, E
--- gets the set-theoretic union of an OrderedSet against another OrderedSet.
---@param otherSet util.OrderedSet<K, E>
---@return util.OrderedSet<K, E>
function OrderedSet:union(otherSet)
  local unionSet = self.new()
  for _, element in ipairs(self.elements) do
    unionSet:add(element)
  end
  for _, element in ipairs(otherSet.elements) do
    unionSet:add(element)
  end
  return unionSet
end

---@generic E
--- unpacks the values represented in the OrderedSet, either returning the
--- values or inserting them into the given table argument.
---@param into E[]? optional target table into which the values are unpacked.
---Specifying a falsy value will force the return statement, while a truthy
---statement will be assumed to be a table and the values will be inserted at
---the end.
---@return E[]? values
function OrderedSet:values(into)
  local vals = vim.tbl_values(self.elements)
  if into then
    vim.list_extend(into, vim.tbl_values(self.elements))
  else
    return vim.tbl_values(self.elements)
  end
end

return OrderedSet
