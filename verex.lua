local mod = {}
local aux = {}

mod.__index = mod

function mod.new(class)
  return setmetatable({}, class)
end

function mod:add(func, ...)
  table.insert(self, { func, ... })
end


function mod:match(str)
  local from = 1
  for i = 1, #self do
    from = self[i][1](str, from, self[i])
    if from == nil then
      return false
    end
  end
  return true
end


function mod:find(str)
  self:add(aux.find, str)
  return self
end

function mod:findPattern(str)
  self:add(aux.findPattern, str)
  return self
end

function mod:maybe(str)
  self:add(aux.maybe, str)
  return self
end

function mod:maybePattern(str)
  self:add(aux.maybePattern, str)
  return self
end


function aux.find(str, from, pattern)
  local b,e = string.find(str, pattern[2], from, true)
  if b == from then
    return e + 1
  end
  return nil
end

function aux.findPattern(str, from, pattern)
  local b,e = string.find(str, pattern[2], from)
  if b == from then
    return e + 1
  end
  return nil
end

function aux.maybe(str, from, pattern)
  local b,e = string.find(str, pattern[2], from, true)
  if b == from then
    return e + 1
  end
  return from
end

function aux.maybePattern(str, from, pattern)
  local b,e = string.find(str, pattern[2], from)
  if b == from then
    return e + 1
  end
  return from
end

return mod
