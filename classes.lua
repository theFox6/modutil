---
--A module for creating classes.
--
--Classes can create objects that use the classes methods.
--Also classes can inherit from eachother.
--
--@module classes
local classes = {}

---
--The lowest class.
--
--It defines the constructor used by all classes.
--
--@type object
--@field #table class the class the object is of
local object = {type_name = "object"}

---
--The constructor for an object.
--
--It creates a new object of the class it is called from.
--If it is called on an object a new object of the same class is created.
--
--@function [parent=#object] new
--@param #table self The class or object to be used as reference for the new object.
--@param #table o The table that should be turned into an object of the class.
--  If a non-table is given a new table object is created.
function object:new(o)
  local meta = getmetatable(o) or {}
  local c = self.class or self
  meta.__index = c
  local n
  if type(o) == "table" then
    n = setmetatable(o,meta)
  else
    n = setmetatable({},meta)
  end
  n.class = c
  return n
end

---
--Create a new class.
--
--This function creates a new class inheriting from the super type or object.
--It returns the newly created class.
--With `your_class:new()` a new object can be created.
--@function [super=#classes] create
--@param #table base The base of the new class to be created. Can contain:  
--  *  #table super: the class this one should inherit from
function classes.create(base)
  local def = base or {}
  if not def.super then
    def.super = object
  end
  if not def.type_name then
    def.type_name = def.super.type_name
  end
  local c = setmetatable(def,{__index = def.super})
  return c
end

return classes
