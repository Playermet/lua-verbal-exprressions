local mod = {}

mod.__index = mod

function mod.new(class)
  return setmetatable({}, class)
end

function mod:add(item)
  table.insert(self, item)
end

function mod:add_sf(...)
  self:add(string.format(...))
end

return mod
