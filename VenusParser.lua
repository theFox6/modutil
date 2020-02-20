local modpath = minetest.get_modpath("modutil")
local vpd = "VenusParser/"
local vpl = modutil.load_lua(vpd.."init")
local vp = vpl(modutil.path.."/"..vpd)
return vp
