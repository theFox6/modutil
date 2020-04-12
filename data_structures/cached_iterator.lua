local classes = modutil.require "classes"
local cached_iterator = classes.create({type_name = "cached_iterator"})

function cached_iterator:new(o,arg)
  local obj
  if type(o) == "function" then
    obj = {iterator = o}
    obj.arg = arg
  elseif type(o) == "table" then
    local it, s = pairs(o)
    obj = {iterator = it, arg = s}
  else
    error(("iterator function or array table expected got %s"):format(o),2)
  end
  return cached_iterator.super.new(self,obj)
end

function cached_iterator:next()
  return self:cache_first(self.iterator(self.arg, self.last_element))
end

function cached_iterator:cache_first(...)
  self.last_element = ...
  return ...
end

function cached_iterator:resetLast()
  self.last_element = nil
end

return cached_iterator
