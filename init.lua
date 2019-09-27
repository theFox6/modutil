minetest.log("action", "["..minetest.get_current_modname().."] loading init")

local modpath = minetest.get_modpath("modutil")

minetest.log("action", "["..minetest.get_current_modname().."] loading log")
local logging = dofile(modpath.."/log.lua")
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
modutil = {portable = false}
local modules = {
  init = modutil, -- just in case anybody tries funny stuff
  log = logging  -- preloaded
}

function modutil.require(module)
  if not modules[module] then
    log.action("loading "..module)
    modules[module] = dofile(modpath.."/"..module..".lua") or true
    log.action("loaded "..module)
  end
  return modules[module]
end

log.action("loaded init")
