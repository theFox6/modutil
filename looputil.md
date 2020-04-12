# number loop
The number loop will generate incrementing numbers and call the given function passing the current number as argument.

arguments:
* min #number default: 0
  * the smallest number to generate
* max #number
  * the largest number to generate
* step #number default: 1
  * the number to add between each iteration
* func #function
  * the function that receives the number as argument
  * return values will be ignored
* stopCond #function default: don't stop until max is reached
  * a function that reveives the number
  * if it returns true (or any truthy value) the loop will be stopped

Ways to use the number loops:

```lua
looputil.forEach.number.between(min,max).abortOn(stopCond).call(func)
looputil.forEach.number.between(min,max).call(func)
looputil.forEach.number.between(from,to,step,func,stopCond)
looputil.forEach.number.between(from,to,step,func)
looputil.forEach.number.between(from,to,func,stopCond)
looputil.forEach.number.between(from,to,func)
looputil.forEach.number.from(min).to(max).stepping(stepSize).abortOn(stopCond).call(func)
looputil.forEach.number.from(min).to(max).stepping(stepSize).call(func)
looputil.forEach.number.from(min).to(max).abortOn(stopCond).call(func)
looputil.forEach.number.from(min).to(max).call(func)
looputil.forEach.number(min,max,stepSize,func,stopCond)
looputil.forEach.number(min,max,stepSize,func)
looputil.forEach.number(min,max,func,stopCond)
looputil.forEach.number(min,max,func)
looputil.forEach.number(max,func)
looputil.forEach(min,max,stepSize,func,stopCond)
looputil.forEach(min,max,stepSize,func)
looputil.forEach(min,max,func,stopCond)
looputil.forEach(min,max,func)
looputil.forEach(max,func)
```

# iterator loop
The loop will iterate over all elements within a table or returned by an iterator.

arguments:
* table #table or #function
  * the table which should be iterated over using pairs
  * can also be an interator function like the return of pairs(table)
* func #function
  * the function that receives the element as argument/s
  * return values will be ignored
* stopCond #function default: don't stop until the end of the table is reached (the iterator returns nil)
  * a function that receives the elements
  * if it returns true (or any truthy value) the loop will be stopped

Ways to use the iterator loops:

```lua
looputil.forEach.pair(table).abortOn(stopCond).call(func)
looputil.forEach.pair(table).call(func)
looputil.forEach.pair(table,func,stopCond)
looputil.forEach.pair(table,func)
looputil.forEach.keyIn(table).abortOn(stopCond).call(func)
looputil.forEach.keyIn(table).call(func)
looputil.forEach.keyIn(table,func,stopCond)
looputil.forEach.keyIn(table,func)
looputil.forEach.valueIn(table).abortOn(stopCond).call(func)
looputil.forEach.valueIn(table).call(func)
looputil.forEach.valueIn(table,func,stopCond)
looputil.forEach.valueIn(table,func)
looputil.forEach(table,func,stopCond)
looputil.forEach(table,func)

-- alias for looputil.forEach.pair
-- looputil.forEach.keyValuePairIn 
```

# numeric index iterator loop
The loop works like the iterator loop for tables but it uses ipairs.

Ways to use the numeric index iterator loops:

```lua
looputil.forEach.ipair(table).abortOn(stopCond).call(func)
looputil.forEach.ipair(table).call(func)
looputil.forEach.ipair(table,func,stopCond)
looputil.forEach.ipair(table,func)
looputil.forEach.integerKeyIn(table).abortOn(stopCond).call(func)
looputil.forEach.integerKeyIn(table).call(func)
looputil.forEach.integerKeyIn(table,func,stopCond)
looputil.forEach.integerKeyIn(table,func)
looputil.forEach.integerIndexedValueIn(table).abortOn(stopCond).call(func)
looputil.forEach.integerIndexedValueIn(table).call(func)
looputil.forEach.integerIndexedValueIn(table,func,stopCond)
looputil.forEach.integerIndexedValueIn(table,func)

-- alias for looputil.forEach.ipair:
-- looputil.forEach.integerIndexedKeyValuePairIn 
```
