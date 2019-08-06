# modutil
A utility mod for minetetest providing useful utilities that can be used in other mods.

## usage
There are several modules in the mod.
These can be loaded on demand.
To load a module use:

```lua
  local your_variable = modutil.require("modulename")
```

The variable then contains the return value of the module.
That will in  most cases be a table or a function.

## log

A module for creating shorter logging functions.  
The loggers will format the given log message and call minetest.log.  
Typically you want to use it as following:

```lua
  my_mod.log = modutil.require("log").make_loggers()
  my_mod.log.action("loggers loaded")
```

You can also pass the level of the loggers to the make_loggers function:

```lua
  my_mod.log = modutil.require("log").make_loggers("action","warning","error","debug")
```

If you create your logger after loading the mod you may want to pass the modname using:

```lua
  my_mod.log.info = modutil.require("log").make_logger("info","my_mod")
```

## translations

A wrapper that checks if `minetest.get_translator` is avalible and replaces it if nessecary.  
The module returns a fucntion that when called returns the translator.
use:

```lua
  my_mod.S = modutil.require("translations")()
  -- or for after loading
  my_mod.S = modutil.require("translations")("my_mod")
```

## check_prefix

A function doing the same as the standard minetest prefix check.
It will assume the modname is correct if it called after loading.
use:

```lua
  local check_prefix = modutil.require("check_prefix")
  -- checks if name is in the format "modname:name" or ":modname:name"
  -- if modname in "modname:name" is not the currently loaded mod it creates an error
  -- returns id in the format "modname:name"
  local id = check_prefix(name)
```

## textures

A module that contains some helpers for textures.
Load it as usual with:
```lua
  textures = modutil.require("textures")
```

```lua
  textures.inventorycube(face_top, face_left, face_right)
```
will create an inventorycube modifier consisting the three given faces

```lua
  textures.get_node_inventory_image(nodename)
```
will return the inventory image of a node
or an inventory cube created from the tiles of the node

## strings

A module that contains some helpers for strings.
Load it as usual with:
```lua
  strings = modutil.require("strings")
  -- to write it into the native string functions do
  modutil.require("strings").overwrite_string()
```

```lua
  strings.starts_with(str, prefix)
  -- if overwritten you can also use
  str:starts_with(prefix)
```
checks if a given string starts with a given other

```lua
  strings.ends_with(str, suffix)
  -- if overwritten you can also use
  str:ends_with(suffix)
```
checks if a given string ends with a given other

# license
This mod is under the MIT License.
Some string and texture utils are from modlib by appgurueu (aka LMD) which is under MIT License.
