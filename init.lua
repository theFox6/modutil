minetest.log("action", "["..minetest.get_current_modname().."] loading init")

--TODO: try to use local_require module

local modpath = minetest.get_modpath("modutil")
local modules = {}
local function load_lua(module)
  modules[module] = dofile(modpath.."/"..module..".lua") or true
  return modules[module]
end

minetest.log("action", "["..minetest.get_current_modname().."] loading log")
local logging = load_lua("log")
local log = logging.make_loggers("debug","action","warning")
log.action("loaded log")

if modutil then
  if modutil.portable then
    log.debug("overriding modutil portable")
  else
    log.warning("non portable modutil was already loaded")
  end
end

log.action("setting modutil global")
modutil = {portable = false, log = log, load_lua = load_lua, path = modpath}
modules.init = modutil -- just in case anybody tries funny stuff

log.action("loading VenusParser")
local vp = modutil.load_lua("VenusParser")
log.action("loaded VenusParser")
function modutil.load_venus(module)
  modules[module] = vp.dovenus(modpath.."/"..module..".venus") or true
  return modules[module]
end

function modutil.require(module,modtype)
  local modt = modtype or "venus"
  if not modules[module] then
    log.action("loading "..module)
    if modt == "venus" then
      modutil.load_venus(module)
    elseif modt == "lua" then
      modutil.load_lua(module)
    else
      error(("bad module type: %s"):format(modt),2)
    end
    log.action("loaded "..module)
  end
  return modules[module]
end

--preload some stuff for now so users are not confused
modutil.require("local_require","lua")

log.action("loaded init")
return modutil
