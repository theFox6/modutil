local classes = modutil.require "classes"
local lu = modutil.require "looputil"
local cit = modutil.require "data_structures/cached_iterator"

--perhaps add serialize and deserialize when in modutil

---
--A data collection that has lots of methods to work with it's data.
--@type data_table
--@field #table super the object type
--@field #string type_name the data_table's type name, "data_table" obviously
local data_table = classes.create({type_name = "data_table"})

function data_table:new(o)
  local obj = o or {}
  if not obj.data then obj.data = {} end
  local n = data_table.super.new(self,obj)
  local meta = getmetatable(n)
  meta.__eq = data_table.equals
  meta.__ipairs = data_table.ipairs
  meta.__pairs = data_table.pairs
  return setmetatable(n,meta)
end

function data_table.from(d)
  return data_table:new({data = d})
end

function data_table.of(...)
  return data_table:new({data = {...}})
end

function data_table.generate(func,arg)
  local n = data_table:new()
  for v in func,arg do
    n:add(v)
  end
  return n
end

function data_table.is_data_table(obj)
  if type(obj) ~= "table" then return false end
  if obj.class ~= data_table then return false end
  if getmetatable(obj).__index ~= data_table then return false end
  return true
end

local function iterate(obj,func,errLvl,stopCond)
  local t = type(obj)
  if t == "table" then
    if data_table.is_data_table(obj) then
      lu.forEach.pair(obj.data,func,stopCond)
    else
      lu.forEach.pair(obj,func,stopCond)
    end
  elseif t == "function" then
    lu.forEach.pair(obj,func,stopCond)
  else
    error(("expected data_table or table got %s"):format(obj),errLvl or 2)
  end
end

local function iit(obj,func,errLvl,stopCond)
  if type(obj) == "table" then
    if data_table.is_data_table(obj) then
      lu.forEach.ipair(obj.data,func,stopCond)
    else
      lu.forEach.ipair(obj,func,stopCond)
    end
  else
    error(("expected data_table or table got %s"):format(obj),errLvl or 2)
  end
end

function data_table:accumulate(accumulator,start)
  local result = start
  for _,v in pairs(self.data) do
    if start == nil and result == nil then
      result = v
    else
      result = accumulator(v,result)
    end
  end
  return result
end

-- idx, value or value only
function data_table:add(idx, value)
  if value then
    if type(idx) == "number" then
      table.insert(self.data,idx,value)
    else
      self.data[idx] = value
    end
  else
    table.insert(self.data,idx)
  end
end

function data_table:addAllValues(other)
  iterate(other,function(_,v) self:add(v) end,3)
end

function data_table:addAllIValues(other)
  iit(other,function(_,v) self:add(v) end,3)
end

function data_table:allMatch(pred)
  for i,v in pairs(self.data) do
    if not pred(i,v) then
      return false
    end
  end
  return true
end

function data_table:anyMatch(pred)
  for i,v in pairs(self.data) do
    if pred(i,v) then
      return true
    end
  end
  return false
end

function data_table:clear()
  self.data = {}
end

function data_table:clone()
  return data_table:new():setAllFrom(self)
end

function data_table:concat(seperator,from,to,all)
  if all then
    local ret = ""
    self:forEachValue(function(v) ret = ret .. seperator .. v end)
    return ret:sub(seperator:len()) + 1
  else
    return table.concat(self.data, seperator,from, to)
  end
end

function data_table:contains(o)
  for _,v in pairs(self.data) do
    if v == o then
      return true
    end
  end
end

function data_table:containsAll(other)
  local data_cache = {}
  local match = true
  local it = cit:new(self.data)
  iterate(other,function(_,ov)
    if data_cache[ov] then
      return
    end
    for mi,mv in it.next do
      data_cache[mv] = mi
      if mv == ov then
        return
      end
    end
    match = false
  end,3,function() return not match end)
  return match
end

function data_table:count()
  local c = 0
  for _ in pairs(self.data) do
    c = c + 1
  end
  return c
end

function data_table:distinct(keepIndex)
  local unique = {}
  local cache = {}
  for i,v in pairs(self.data) do
    if not cache[v] then
      cache[v] = i
      if keepIndex then
        table.insert(unique,i,v)
      else
        table.insert(unique,v)
      end
    end
  end
  return data_table.from(unique)
end

function data_table:forEach(func)
  for i,v in pairs(self.data) do
    func(i,v)
  end
end

--TODO until doc

function data_table:forEachI(func)
  for i,v in ipairs(self.data) do
    func(i,v)
  end
end

function data_table:forEachIUntil(func,pred)
  for i,v in ipairs(self.data) do
    if pred(i,v) then return end
    func(i,v)
  end
end

function data_table:forEachIValue(func)
  for _,v in ipairs(self.data) do
    func(v)
  end
end

function data_table:forEachIValueUntil(func,pred)
  for _,v in ipairs(self.data) do
    if pred(v) then return end
    func(v)
  end
end

function data_table:forEachUntil(func,pred)
  for i,v in pairs(self.data) do
    if pred(i,v) then return end
    func(i,v)
  end
end


function data_table:forEachValue(func)
  for _,v in pairs(self.data) do
    func(v)
  end
end

function data_table:forEachValueUntil(func,pred)
  for _,v in pairs(self.data) do
    if pred(v) then return end
    func(v)
  end
end

--end until doc

-- Warning: this is only a shallow compare it does not compare the contents of tables within the data_tables
-- But it does compare nested data_tables and all other objects with a __eq metamethod
function data_table:equals(other)
  if not data_table.is_data_table(other) then
    return false
  end
  local it = cit:new(self.data)
  for oi,ov in pairs(other.data) do
    local mi,mv = it:next()
    if mi ~= oi then
      return false
    end
    if mv ~= ov then
      return false
    end
  end
  if it:next() ~= nil then
    return false
  end
  return true
end

function data_table:filter(func)
  local indexes = {}
  for i,v in pairs(self.data) do
    if not func(v) then
      table.insert(indexes,1,i)
    end
  end
  for _,i in pairs(indexes) do
    self:remove(i)
  end
end

function data_table:get(idx)
  return self.data[idx]
end

function data_table:icount()
  return #self.data
end

function data_table:indexOf(value)
  for i,v in pairs(self.data) do
    if v == value then
      return i
    end
  end
end

function data_table:ipairs()
  return ipairs(self.data)
end

function data_table:isEmpty()
  return next(self.data) == nil
end

function data_table:keys()
  local k = {}
  for i in pairs(self.data) do
    table.insert(k,i)
  end
  return data_table:from(k)
end

function data_table:kvSwapped()
  local reversed = {}
  for i,v in pairs(self.data) do
    if reversed[v] then
      error("cannot use non-unique values as key",2)
    end
    reversed[v] = i
  end
  return data_table:from(reversed)
end

function data_table:lastIndexOf(value)
  local li
  for i,v in pairs(self.data) do
    if v == value then
      li = i
    end
  end
  return li
end

function data_table:map(func)
  for i,v in pairs(self.data) do
    self.data[i] = func(v)
  end
end

function data_table:max(comp)
  local c = comp or function(a,b) return a > b end
  local max,mi
  for i,v in pairs(self.data) do
    if max == nil then
      max = v
      mi = i
    else
      if c(v,max) then
        max = v
        mi = i
      end
    end
  end
  return max,mi
end

function data_table:noneMatch(pred)
  for i,v in pairs(self.data) do
    if pred(i,v) then
      return false
    end
  end
  return true
end

function data_table:pairs()
  return pairs(self.data)
end

function data_table:randomElement()
  local keys = self:keys()
  local n = math.random(1, keys:icount())
  local k = keys:get(n)
  return self:get(k), k, n
end

function data_table:randomKeys(n,unique)
  local keys = self:keys()
  local randKeys = {}
  if unique then
    if n > keys:icount() then
      error("cannot get more unique keys than avalible",2)
    end
    for _ = 0, n do
      table.insert(randKeys,keys:remove(math.random(1, keys:icount())))
    end
  else
    local kc = keys:icount()
    for _ = 0, n do
      table.insert(randKeys,keys:get(math.random(1, kc)))
    end
  end
  return data_table.from(randKeys)
end

function data_table:remove(idx)
  if (not idx) or type(idx) == "number" then
    return table.remove(self.data,idx)
  else
    local v = self.data[idx]
    self.data[idx] = nil
    return v
  end
end

function data_table:removeIf(func)
  local indexes = {}
  for i,v in pairs(self.data) do
    if func(i,v) then
      table.insert(indexes,1,i)
    end
  end
  for _,i in pairs(indexes) do
    self:remove(i)
  end
end

function data_table:removeValue(value)
  self:remove(self:indexOf(value))
end

function data_table:removeValues(collection)
  local it = cit:new(self)
  local data_cache = {}
  local indexes = {}
  iterate(collection, function(_,rv)
    local rvc = data_cache[rv]
    if rvc then
      local ci,nexti = next(rvc)
      if nexti then
        table.insert(indexes,1,nexti)
        table.remove(rvc,ci)
        return
      end
    end
    for mi,mv in it:next() do
      if mv == rv then
        table.insert(indexes,1,mi)
        return
      else
        local cached = data_cache[mv]
        if cached then
          table.insert(cached,mi)
        else
          data_cache[mv] = {mi}
        end
      end
    end
  end,3)
  for _,i in pairs(indexes) do
    self:remove(i)
  end
end

function data_table:set(idx, value)
  self.data[idx] = value
end

function data_table:setAllFrom(other)
  iterate(other, function(i,v) self:set(i,v) end, 3)
end

function data_table:sort(comparator)
  table.sort(self.data,comparator)
end

function data_table:sublist(from,to,removeIndex)
  local sub = {}
  local start = false
  for i,v in pairs(self.data) do
    if i == from then
      start = true
    end
    if start then
      if removeIndex then
        table.insert(sub,v)
      else
        table.insert(sub,i,v)
      end
    end
    if i == to then
      return data_table.from(sub)
    end
  end
  return data_table.from(sub)
end

return data_table
