local classes = modutil.require "classes"

local stack = classes.create({type_name = "stack", super = modutil.require("data_structures/data_table")})

function stack:new(o)
  local obj = o or {}
  local n = stack.super.new(self,obj)
  return n
end

function stack:add(idx, value)
  if value then
    stack.super.add(idx,value)
  else
    --insert at stacks head
    table.insert(self.data,1,idx)
  end
end

function stack:get(idx)
  if idx then
    return stack.super.get(idx)
  else
    return next(self.data)
  end
end

function stack:remove(idx)
  if idx then
    return stack.super.remove(self,idx)
  else
    --get the stack's head
    return table.remove(self.data,1)
  end
end
