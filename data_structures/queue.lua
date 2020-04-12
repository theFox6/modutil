local classes = modutil.require "classes"

local queue = classes.create({type_name = "queue", super = modutil.require("data_structures/data_table")})

function queue:new(o)
  local obj = o or {}
  local n = queue.super.new(self,obj)
  return n
end

function queue:get(idx)
  if idx then
    return queue.super.get(idx)
  else
    return next(self.data)
  end
end

function queue:remove(idx)
  if idx then
    return queue.super.remove(self,idx)
  else
    --get the queue's head
    return table.remove(self.data,1)
  end
end
