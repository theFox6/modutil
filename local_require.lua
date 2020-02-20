local function make_table(modtable, moduletable)
  local modules = moduletable or {}
  
  if not modules.init then
    modules.init = modtable
  end
  if not modules.log then
    modules.log = modutil.require("log").make_loggers()
  end
  
  --TODO: support for venus files
  
  local function local_require(module)
    local log = modules.log or modutil.log
    if not modules[module] then
      log.info("loading "..module)
      modules[module] = dofile(modtable.modpath.."/"..module..".lua") or true
      log.info("loaded "..module)
    end
    return modules[module]
  end
  
  modtable.require = local_require
end

return make_table
