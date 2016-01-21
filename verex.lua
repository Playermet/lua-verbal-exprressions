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
      return
    end
  end
  return from
end


function mod:find(str)
  if self == mod then self = mod:new() end
  self:add(aux.find, str)
  return self
end

function mod:find_pattern(str)
  if self == mod then self = mod:new() end
  self:add(aux.find_pattern, str)
  return self
end

function mod:maybe(str)
  if self == mod then self = mod:new() end
  self:add(aux.maybe, str)
  return self
end

function mod:maybe_pattern(str)
  if self == mod then self = mod:new() end
  self:add(aux.maybe_pattern, str)
  return self
end


function aux.find(str, from, pattern)
  local b,e = string.find(str, pattern[2], from, true)
  if b == from then
    return e + 1
  end
  return nil
end

function aux.find_pattern(str, from, pattern)
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

function aux.maybe_pattern(str, from, pattern)
  local b,e = string.find(str, pattern[2], from)
  if b == from then
    return e + 1
  end
  return from
end

function aux.is_substring(str, from, pattern)
  for i = 1, #pattern[2] do
    if not aux.compare_bytes(str, i+from-1, pattern[2], i) then
      return
    end
  end
  return from + #pattern[2]
end

function aux.is_substring_ci(str, from, pattern)
  local patt = pattern[2]
  for i = 1, #patt do
    if not aux.compare_bytes_ci(str, i+from-1, pattern[2], i) then
      return
    end
  end
  return from + #patt
end

function aux.compare_bytes(a,i,b,j)
  return string.byte(a,i) == string.byte(b,j)
end

function aux.compare_bytes_ci(a,i,b,j)
  return aux.byte_to_lower(string.byte(a,i))
      == aux.byte_to_lower(string.byte(b,j))
end

function aux.byte_to_lower(byte)
  if byte >=65 and byte <= 90 then
    return byte + 32
  end
  return byte
end

return mod
