return function (mutil)
  local modpath = mutil.modpath
  local modules = {}
  
  minetest.log("action", "["..minetest.get_current_modname().."] loading log")
  local logging = dofile(modpath.."/log.lua")
  modules.log = logging
  local log = logging.make_loggers("debug","action","warning")
  log.action("loaded log")
  mutil.log = log
  
  modules.loader = function()
    log.warning("modutil's loader cannot be used as a module")
  end
  
  log.action("loading VenusParser")
  local vpd = "VenusParser/"
  local vpl = dofile(vpd.."init.lua")
  modules["VenusParser/init"] = vpl
  local vp = vpl(mutil.modpath.."/"..vpd)
  log.action("loaded VenusParser")
  modules.VenusParser = vp
  
  log.action("loading local_require")
  local lreq = dofile(modpath.."/local_require.lua")
  log.action("loaded local_require")
  modules.local_require = lreq
  
  mutil.require = lreq(mutil,modules)
end
