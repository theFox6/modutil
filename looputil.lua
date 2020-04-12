local looputil = {}

local function numberLoop(from,to,step,func,stopCond)
  if stopCond then
    if step then
      for i = from, to, step do
        if stopCond(i) then return end
        func(i)
      end
    else
      for i = from, to do
        if stopCond(i) then return end
        func(i)
      end
    end
  else
    if step then
      for i = from, to, step do
        func(i)
      end
    else
      for i = from, to do
        func(i)
      end
    end
  end
end

local numbers = {
  between = function(from,to,step,func,stopCond)
    if step then
      if type(step) == "number" then
        numberLoop(from,to,step,func,stopCond)
      elseif type(step) == "function" then
        --step = func, func = stopCond
        numberLoop(from,to,false,step,func)
      else
        error(("expected argument #3 to be step size or function, got %s"):format(step),2)
      end
    else
      return {
        abortOn = function(stopCond)
          return {
            call = function(func)
              numberLoop(from,to,false,func,stopCond)
            end
          }
        end,
        call = function(func)
          numberLoop(from,to,false,func)
        end
      }
    end
  end,
  from = function(from)
    return {
      to = function(to)
        return {
          stepping = function(stepSize)
            return {
              abortOn = function(stopCond)
                return {
                  call = function(func)
                    numberLoop(from,to,stepSize,func,stopCond)
                  end
                }
              end,
              call = function(func)
                numberLoop(from,to,stepSize,func)
              end
            }
          end,
          abortOn = function(stopCond)
            return {
              call = function(func)
                numberLoop(from,to,false,func,stopCond)
              end
            }
          end,
          call = function(func)
            numberLoop(from,to,false,func)
          end
        }
      end
    }
  end
}

setmetatable(numbers,{__call = function(self,from,to,step,func,stopCond)
  if from then
    if step == nil then
      --from = to, to = func
      numberLoop(0,from,to)
    elseif type(step) == "number" then
      numberLoop(from,to,step,func,stopCond)
    elseif type(step) == "function" then
      --step = func, func = stopCond
      numberLoop(from,to,false,step,func)
    else
      error(("expected argument #3 to be a step size or function, got %s instead"):format(step),2)
    end
  else
    return self
  end
end})

local function getIterator(table,default)
  local dgen = default or pairs
  if type(table) == "function" then
    return table
  elseif type(table) == "table" then
    return dgen(table)
  else
    error(("expected argument #1 to be a table array or an iterator function, got %s instead"):format(table),3)
  end
end

local function pairLoop(table,func,stopCond)
  local iterator = getIterator(table)
  if stopCond then
    for i,v in iterator do
      if stopCond(i,v) then return end
      func(i,v)
    end
  else
    for i,v in iterator do
      func(i,v)
    end
  end
end

local function keyLoop(table,func,stopCond)
  local iterator = getIterator(table)
  if stopCond then
    for i in iterator do
      if stopCond(i) then return end
      func(i)
    end
  else
    for i in iterator do
      func(i)
    end
  end
end

local function valueLoop(table,func,stopCond)
  local iterator = getIterator(table)
  if stopCond then
    for _,v in iterator do
      if stopCond(v) then return end
      func(v)
    end
  else
    for _,v in iterator do
      func(v)
    end
  end
end

local forEach = {
  number = numbers,
  pair = function(table,func,stopCond)
    if func then
      pairLoop(table,func,stopCond)
    else
      return {
        abortOn = function(stopCond)
          return {
            call = function(func)
              pairLoop(table,func,stopCond)
            end
          }
        end,
        call = function(func)
          pairLoop(table,func)
        end
      }
    end
  end,
  keyIn = function(table,func,stopCond)
    if func then
      keyLoop(table,func,stopCond)
    else
      return {
        abortOn = function(stopCond)
          return {
            call = function(func)
              keyLoop(table,func,stopCond)
            end
          }
        end,
        call = function(func)
          keyLoop(table,func)
        end
      }
    end
  end,
  valueIn = function(table,func,stopCond)
    if func then
      valueLoop(table,func,stopCond)
    else
      return {
        abortOn = function(stopCond)
          return {
            call = function(func)
              valueLoop(table,func,stopCond)
            end
          }
        end,
        call = function(func)
          valueLoop(table,func)
        end
      }
    end
  end,
  ipair = function(table,func,stopCond)
    if func then
      pairLoop(ipairs(table),func,stopCond)
    else
      return {
        abortOn = function(stopCond)
          return {
            call = function(func)
              pairLoop(ipairs(table),func,stopCond)
            end
          }
        end,
        call = function(func)
          pairLoop(ipairs(table),func)
        end
      }
    end
  end,
  integerKeyIn = function(table,func,stopCond)
    if func then
      keyLoop(ipairs(table),func,stopCond)
    else
      return {
        abortOn = function(stopCond)
          return {
            call = function(func)
              keyLoop(ipairs(table),func,stopCond)
            end
          }
        end,
        call = function(func)
          keyLoop(ipairs(table),func)
        end
      }
    end
  end,
  integerIndexedValueIn = function(table,func,stopCond)
    if func then
      valueLoop(ipairs(table),func,stopCond)
    else
      return {
        abortOn = function(stopCond)
          return {
            call = function(func)
              valueLoop(ipairs(table),func,stopCond)
            end
          }
        end,
        call = function(func)
          valueLoop(ipairs(table),func)
        end
      }
    end
  end,
}
forEach.keyValuePairIn = forEach.pair
forEach.integerIndexedKeyValuePairIn = forEach.ipair

setmetatable(forEach,{__call = function(self,fst,snd,trd,fou,fif)
  if not fst then
    return self
  elseif type(fst) == "table" then
    pairLoop(fst,snd,trd)
  elseif type(fst) == "function" then
    pairLoop(fst,snd,trd)
  elseif type(fst) == "number" then
    numbers(fst,snd,trd,fou,fif)
  else
    error(("bad argument #1 to forEach: %s"):format(fst),2)
  end
end})
looputil.forEach = forEach

return looputil
