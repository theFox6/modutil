local loader = minetest.get_current_modname()
minetest.log("action", "["..loader.."] loading modutil portable")

--TODO: properly sync with init.lua
--  eventually create a module/utility file or let init.lua call portable.lua

local loader_path = minetest.get_modpath(loader)
local modutil_path = loader_path.."/modutil"
do
	local handle = io.open(modutil_path.."/init.lua","r")
	if handle then
		io.close(handle)
	else
		minetest.log("error", "modutil was expected at: " .. modutil_path)
		error("modutil portable could not be found inside loading mod: "..loader)
	end
end

local portable = {portable = true, path = modutil_path}
local modules = {}
function portable.load_lua(module)
  modules[module] = dofile(modutil_path.."/"..module..".lua") or true
  return modules[module]
end

minetest.log("action", "["..minetest.get_current_modname().."] loading log")
local logging = portable.load_lua("log")
local log = logging.make_loggers("action","debug")
log.action("loaded log")

portable.log = log
modules.init = portable -- just in case anybody tries funny stuff

if modutil then
  log.debug("modutil already loaded")
else
  log.action("setting modutil global")
  modutil = portable
end

local vp = portable.load_lua("VenusParser")
function portable.load_venus(module)
  modules[module] = vp.dovenus(modutil_path.."/"..module..".venus") or true
  return modules[module]
end

function portable.require(module,modtype)
  local modt = modtype or "venus"
  if not modules[module] then
    log.action("loading "..module)
    if modt == "venus" then
      portable.load_venus(module)
    elseif modt == "lua" then
      portable.load_lua(module)
    else
      error(("bad module type: %s"):format(modt),2)
    end
    log.action("loaded "..module)
  end
  return modules[module]
end

log.action("loaded portable")
return portable
