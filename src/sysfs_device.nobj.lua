-- Copyright (c) 2013 by Christian Wiese <chris@opensde.org>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

--
-- sysfs device access
--

-- typedefs
local typedefs = [[
typedef struct sysfs_device device;
]]
c_source "typedefs" (typedefs)
-- pass extra C type info to FFI.
ffi_cdef (typedefs)

--
-- device
--
object "device" {
	c_source {
	[[

/* internal sysfs device iterator function */
static int lua_sysfs_device_iterator(lua_State *L) {
	struct dlist *list = (struct dlist *) lua_touserdata(L, lua_upvalueindex(1));
	struct sysfs_device *obj;

	/* TODO: clarify the flag types
	 * OBJ_UDATA_FLAG_OWN segfaults here with lua and luajit
	 * OBJ_UDATA_FLAG_LOOKUP works with lua but segfaults with luajit
	 */
	int obj_flags = 0;

	if ((obj = dlist_next(list)) != NULL) {
		obj_type_device_push(L, obj, obj_flags);
		return 1;
	} else {
		return 0;
	}
}
	]]
},
	-- open
	constructor "open" {
		c_call "device *" "sysfs_open_device" {
						"const char *", "bus",
						"const char *", "bus_id"
		}
	},
	-- close
	destructor "close" {
		c_method_call "void" "sysfs_close_device" {}
	},
	-- open tree
	constructor "open_tree" {
		c_call "device *" "sysfs_open_device_tree" {
						"const char *", "path",
		}
	},
	-- close tree
	destructor "close_tree" {
		c_method_call "void" "sysfs_close_device_tree" {}
	},
	-- open path
	constructor "open_path" {
		c_call "device *" "sysfs_open_device_path" {
						"const char *", "path",
		}
	},
	-- get parent device
	method "get_parent" {
		c_method_call "device *" "sysfs_get_device_parent" {}
	},
	-- get bus
	method "get_bus" {
		c_method_call "int" "sysfs_get_device_bus" {}
	},
	--
	-- lua binding specific methods for accessing 'struct sysfs_device' members
	--
	-- get name
	method "get_name" {
		c_source[[
  lua_pushstring(L, ${this}->name);
  return 1;
		]]
	},
	-- get path
	method "get_path" {
		c_source[[
  lua_pushstring(L, ${this}->path);
  return 1;
		]]
	},
	-- get id
	method "get_bus_id" {
		c_source[[
  lua_pushstring(L, ${this}->bus_id);
  return 1;
		]]
	},
	-- TODO: 'bus' field
	-- ${this}->bus);

	-- get driver_name
	method "get_driver_name" {
		c_source[[
  lua_pushstring(L, ${this}->driver_name);
  return 1;
		]]
	},
	-- get subsystem
	method "get_subsystem" {
		c_source[[
  lua_pushstring(L, ${this}->subsystem);
  return 1;
		]]
	},
}
