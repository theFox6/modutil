local log = modutil.require("log").make_loggers("warning")

local function formatter(str, ...)
  local arg = {n=select('#', ...), ...}
  return str:gsub("@(.)", function (matched)
    local c = string.byte(matched)
    if string.byte("1") <= c and c <= string.byte("9") then
      return arg[c - string.byte("0")]
    else
      return matched
    end
  end)
end

local function get_translator(mod)
  local modname = mod or minetest.get_current_modname()
  local S
  if minetest.get_translator then
    S = minetest.get_translator(modname)
  else
    log.warning("minetest translator not found!")
    S = formatter
  end
  return S
end

return get_translator
