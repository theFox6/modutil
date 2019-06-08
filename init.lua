local init = os.clock()
minetest.log("action", "["..minetest.get_current_modname().."] loading...")

modutil = {}
local modpath = minetest.get_modpath("modutil")

local modules = {
  init = modutil -- just in case anybody tries funny stuff
}

function modutil.require(module)
  if not modules[module] then
    modules[module] = dofile(modpath.."/"..module..".lua") or true
  end
  return modules[module]
end

local log = modutil.require("log").make_loggers("action")

local time_to_load = os.clock() - init
log.action("loaded in %.4f s", time_to_load)
