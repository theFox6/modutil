A data table is a collection containing data.  
It has lots of methods that can be used to work with the data.

# creating data tables
The `data_table` in this context should be the return of the `data_table` lua file.  
Loaded for example with:
```lua
local data_table = require "data_table"
```

`data_table:new(o)`
creates a new data table
* o #table optional
  * the object the data table should be based on
  * every deserialized data_table has to be be passed to `data_table:new(o)` before it works properly
  * to pass contents use `data_table:from` or `data_table:of`

`data_table.from(d)`
creates a new data table using the table passed as argument to contain it's data
* d #table
  * the table you would like to have as content of the created object
  * if changes are made to the passed table it will also change the data table's contents
if you want an independent copy do something like the following:
```lua
local dt = data_table:new()
dt:setAllFrom(d)

-- or

local dt = data_table.generate(pairs(d))
```

`data_table.of(...)`
creates a new data table using the passed arguments as data  
example:
```lua
local dt = data_table.of("foo","bar",2)
dt:forEach(print)
-- this will print:
-- 1	foo
-- 2	bar
-- 3	2
```

`data_table.generate(func,arg)`
This will call func until it returns nil and add the return values to a newly created data_table.
* func #funtion
  * the provider for the data_tables contents
  * receives the passed arg as first argument
  * receives it's last return value as second argument
* arg optional
  * the first argument for the provider function

`data_table.is_data_table(obj)`
checks whether obj is a data_table

# working with data_tables
The data_table in this context is the return value of one of the creation functions.  
Calling one of these on the data_table class will result in errors.

`data_table:accumulate(accumulator,start)`
Returns the result of an accumulation of all elements.
* accumulator #function
  * the function that does one accumulation
  * it receives two arguments and is expected to return one vlaue
  * example: `function(a,b) return a + b end`
  * by default the first and the second element of the data table will be given in the first iteration
  * the following iterations get the last return and the next element
  * when all elements were accumulated the last return of the accumulator is the final result
* start optional
  * the value to pass to the first iteration instead of waiting for the second element
  * if it is not given the first iteration skips the accumulation and starts at the second element

`data_table:add(idx, value)`
inserts the given value at the given position
* idx
  * the position to insert the element at
  * if it is numeric its behavior is like table.insert (moving others if occupied)
  * if it is not numeric its behavior is like "set"
  * if the second argument is not given it is treated as value
  * if the second argument is not given the index defaults to the end of the list
* value optional
  * the value to insert at the specified place
  * if it is not given the first argument will be treated as value
It's syntax without index is `data_table:add(value)`.  
Trying to do `data_table:add(nil,value)` will likely result in an error.

`data_table:addAllValues(other)`
Adds all the values from the other data_table, table or iterator function to this data_table.
They will be added at the numerical end of this data table.

`data_table:addAllIValues(other)`
Add all numerical indexed values from the other data_table or table to this data_table.
Like addAllValues but it uses ipairs.

`data_table:allMatch(pred)`
Checks if all key-value-pairs of this data table match the given predicate.
* pred #function
  * gets the index as first argument
  * gets the value as second argument
  * should return a boolean whether the element was a match
  * example: `function(_,v) return v < 10 end`

`data_table:anyMatch(pred)`
checks if any key-value-pair matches the given predicate  
works like allMatch

`data_table:clear()`
Removes all elements from the data table.
It does so by replacing the data by an empty table. 

`data_table:clone()`
Returns an independent copy of this data_table.
This is not a deep copy! Table references in the data will be the same.

`data_table:concat(seperator,from,to,all)`
Returns the string concatenating all elements of the list.
* seperator #string optional
  * the string to put between the elements
* from #number optional
  * where to start concatenating
* to #number optional
  * where to stop concatenating
* all #boolean optional
  * whether to include all values
  * by default only the integer indexed values (ipairs) are concatenated

`data_table:contains(o)`
Checks if the data table contains a value equal to o.

`data_table:containsAll(other)`
Checks if the data table contains all values from the data_table, table or iterator function "other".

`data_table:count()`
Returns the number of elements within the data table.  
The count also includes non-numeric indexed elements.  
This is slower than icount.

`data_table:distinct(keepIndex)`
Returns a data_table containing all unique elements.
If an elements value is equal to another's value it is not considered unique.
* keepIndex #boolean optional
  * If keepIndex is true the unique elements in the returned data_table have the same index as the first occurences of the values.
  * If keepIndex is false or nil (not given) the unique elements will have numeric indexes that are all affected by ipairs like operations.

`data_table:forEach(func)`
Passes each key-value-pair in the data table to the given "func"
* func #function
  * gets the index as first argument
  * gets the value as second argument

`data_table:forEachI(func)`
Passes each numeric key-value-pair to the "func".
Works like forEach but uses ipairs.

`data_table:forEachIUntil(func,pred)`
Like forEachI but it stops if the pred function returns true.  
The pred function gets the same arguments as the func.

`data_table:forEachIValue(func)`
Passes each numeric indexed value to the "func".
* func #function
  * gets the value as first and only argument

`data_table:forEachIValueUntil(func,pred)`
Like forEachIValue but it stops if the pred function returns true.  
The pred function gets the same arguments as the func.

`data_table:forEachUntil(func,pred)`
Like forEach but it stops if the pred function returns true.  
The pred function gets the same arguments as the func.

`data_table:forEachValue(func)`
Passes each value to the "func".

`data_table:forEachValueUntil(func,pred)`
Like forEachValue but it stops if the pred function returns true.  
The pred function gets the same arguments as the func.

`data_table:equals(other)`
Compares the data table to another.
Does the same as `dt1 == dt2`.  
If the data_tables contain the same values it returns true.  
This is only a shallow compare it does not compare the contents of tables within the data_tables.  
It does compare nested data_tables and all other objects with the __eq metamethod.  
May end up in endless recursion if this data_table contains the other or the other contains this one.

`data_table:filter(func)`
Removes all values that do not match the given predicate.
* func #function
  * gets the value as first and only argument
  * if it returns true (or any other truthy value) the element is kept in the data table if not the element is removed
  * example: `function(v) return v > 10 end`
see also: `data_table:removeIf(func)`

`data_table:get(idx)`
returns the data at the given index

`data_table:icount()`
Returns the count of numeric indexed values.
To be exact the integer values starting with one until there is a gap.  
Some code to visualize:
```lua
print(data_table:of(1,2,3):icount()) -- will print 3
print(data_table:from({1,2,3}):icount()) -- will also print 3
print(data_table:from{1,2,t="foo"}:icount()) -- will print 2

local dt = data_table:new()
dt:add(1)
dt:set(1,2)
dt:set("foo","bar")
print(dt:icount()) --will print 1
print(dt:count()) --will print 2
```

`data_table:indexOf(value)`
Returns the index of the first occurence of the value.  
Returns nothing (nil) if the value cannot be found.

`data_table:ipairs()`
Returns the ipairs iterator over the data.
```lua
for i,v in data_table:of(2,1):ipairs() do
	print(i,v)
end
-- will print:
-- 1	2
-- 2	1
```

`data_table:isEmpty()`
Returns whether there are no elements in the data table.

`data_table:keys()`
Returns a data table containing the keys indexed with subsequent integers (can be iterated over with ipairs).

`data_table:kvSwapped()`
Returns a data table that has the values as keys and the keys as values.
This is only possible if the values are unique. 

`data_table:lastIndexOf(value)`
Returns the last index of the given value.

`data_table:map(func)`
Replaces each value by the return of the "func".
* func #function
  * receives the value as argument
  * the elements' value is replaced it's return
  * example: `function(v) return v+1 end`

`data_table:max(comp)`
Returns the value and its index that never got a false while comparing.  
The first return is the value the second is the index.
* comp #function optional
  * The comperator defaults to `function(a,b) return a > b end` which will find the largest value.
  * If the comperator returns true the value is considered larger/more important than the current max value.
  * Example: `function(a,b) return #a < #b end` will find the shortest sequence (string/table)
Example:
```lua
local v, i = data_table:of(3,2,5,1,4):max(function(a,b) return a < b end)
print(("min is %q at %i"):format(v,i))
-- will print: min is "1" at 4
```

`data_table:noneMatch(pred)`
Returns whether no key-value-pair matches the given predicate.
Works like allMatch.

`data_table:pairs()`
Returns the pairs iterator over the data.

`data_table:randomElement()`
Returns a random element from the table.
First return value is the value.
Second return value is the key.
Third return value is the index of the key.
If you want to use this multiple times consider using randomKeys.

`data_table:randomKeys(n,unique)`
Returns a data_table containing n random keys.
If unique is true the none of the keys will be a duplicate.

Example for randomly iterating through a data_table:
```lua
--a (local) dt variable should contain the data table
dt:randomKeys(dt:count(),true):forEachValue(function(i)
	print(dt:get(i))
end)
```

`data_table:remove(idx)`
Removes the value at the given index and returns it.
If the index is within the bounds of the integer indexes from 1 to the first absent
the elements after will be moved.  
If the element 1 is removed all elements after that will be moved back by one index.  
Just like `table.remove(tab,idx)`.

`data_table:removeIf(func)`
Remove all key-value-pairs that match the given predicate.
* func #function
  * receives the key as fist argument
  * receives the value as second argument
  * if it returns true (a thruthy value) the element will subsequently be removed

`data_table:removeValue(value)`
removes the first occurence of the given value

`data_table:removeValues(collection)`
Removes all values that are the same as in the given data_table/table/iterator function.

`data_table:set(idx, value)`
sets the given index to the given value

`data_table:setAllFrom(other)`
Sets all elements from the given data_table/table/iterator function.
Equivalent operation for normal lua tables:
```lua
for i,v in pairs(other) do
  self[i] = v
end
```

`data_table:sort(comparator)`
sort the data by the given comperator
just like table.sort

`data_table:sublist(from,to,removeIndex)`
Return a data_table containing all elements within the given bounds.
* from
  * the index to start making the sublist at
* to
  * the index to stop making the sublist at
* removeIndex #boolean optional
  * if true the elements are always inserted at the end of the sublist resulting in a new ipairs iteratable data table
  * if false or nil (not given) the elements in the sublist will have the same indexes as in the original
if the "to" index can not be found (eg. when it's nil) the sublist will contain all elements after the "from" index
if the "from" index can't be found it will return an empty data table 
