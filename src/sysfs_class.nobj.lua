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
-- sysfs class access
--

-- typedefs
local typedefs = [[
typedef struct sysfs_class sysfs_class;
typedef struct sysfs_class_device class_device;
]]
c_source "typedefs" (typedefs)
-- pass extra C type info to FFI.
ffi_cdef (typedefs)

--
-- class device
--
object "class_device" {
	-- open
	constructor "open" {
		c_call "class_device *" "sysfs_open_class_device" {
						"const char *", "classname",
						"const char *", "name"
		}
	},
	-- open path
	constructor "open_path" {
		c_call "class_device *" "sysfs_open_class_device_path" {
						"const char *", "path"
		}
	},
	-- get class device parent
	constructor "get_parent" {
		c_call "class_device *" "sysfs_get_classdev_parent" {
						"class_device *", "clsdev"
		}
	},
	-- get class device
	constructor "get" {
		c_call "class_device *" "sysfs_get_class_device" {
						"sysfs_class *", "class",
						"const char *", "name"
		}
	},
	-- close
	destructor "close" {
		c_method_call "void" "sysfs_close_class_device" {}
	},
	-- get device
	method "get_device" {
		c_method_call "device *" "sysfs_get_classdev_device" {}
	},
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
	-- get classname
	method "get_classname" {
		c_source[[
  lua_pushstring(L, ${this}->classname);
  return 1;
		]]
	},
	-- get attribute
	method "get_attribute" {
		c_method_call "attribute *" "sysfs_get_classdev_attr" {
						"const char *", "name"
		}
	},
	-- get attributes
	method "get_attributes" {
		c_method_call "dlist *" "sysfs_get_classdev_attributes" {}
	},
}


--
-- sysfs class
--
object "sysfs_class" {
	-- open
	constructor "open" {
		c_call "sysfs_class *" "sysfs_open_class" { "const char *", "name" }
	},
	-- close
	destructor "close" {
		c_method_call "void" "sysfs_close_class" {}
	},
	-- get a list of devices
	method "get_devices" {
		c_method_call "dlist *" "sysfs_get_class_devices" {}
	},

c_source {
[[

static int class_device_iter (lua_State *L) {
	struct dlist *clsdevlist = (struct dlist *) lua_touserdata(L, lua_upvalueindex(1));
	struct sysfs_class_device *obj;

	/* TODO: clarify the flag types
	 * OBJ_UDATA_FLAG_OWN segfaults here with lua and luajit
	 * OBJ_UDATA_FLAG_LOOKUP works with lua but segfaults with luajit
	 */
	int obj_flags = 0;

	if ((obj = dlist_next(clsdevlist)) != NULL) {
		obj_type_class_device_push(L, obj, obj_flags);
		return 1;
	} else {
		return 0;
	}
}
]]
},
	-- get a list of devices
	method "get_class_devices" {
		c_source[[
  struct dlist *clsdevlist;

  clsdevlist = sysfs_get_class_devices(${this});

  if (clsdevlist) {
		dlist_start(clsdevlist);
		lua_pushlightuserdata(L, clsdevlist);
		lua_pushcclosure(L, class_device_iter, 1);
		return 1;
  } 
		]],
	},
}
