local loader = minetest.get_current_modname()
minetest.log("action", "["..loader.."] loading modutil portable")

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

minetest.log("action", "["..minetest.get_current_modname().."] loading log")
local logging = dofile(modutil_path.."/log.lua")
local log = logging.make_loggers("action","debug")
log.action("loaded log")

local portable = {portable = true, log = log}
local modules = {
  init = portable, -- just in case anybody tries funny stuff
  log = logging  -- preloaded
}

function portable.require(module)
  if not modules[module] then
    log.action("loading "..module)
    modules[module] = dofile(modutil_path.."/"..module..".lua") or true
    log.action("loaded "..module)
  end
  return modules[module]
end

if modutil then
	log.debug("modutil already loaded")
else
	log.action("setting modutil global")
	modutil = portable
end

log.action("loaded portable")
return portable
