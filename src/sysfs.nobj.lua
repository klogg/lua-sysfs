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
-- typedefs
--
local typedefs = [[
typedef struct sysfs_class class;
typedef struct sysfs_class_device class_device;
typedef struct dlist dlist;
]]
c_source "typedefs" (typedefs)
-- pass extra C type info to FFI.
ffi_cdef (typedefs)

--
-- Functions
--

c_function "get_mnt_path" {
	var_out { "char *", "mnt_path" },
	c_source[[
  char path[PATH_MAX];

  if (sysfs_get_mnt_path(path, PATH_MAX)) {
	lua_pushnil(L);
	return 1;
  } else {
	${mnt_path} = path;
  }
]],
}

--
-- dlist
--

object "dlist" {
}

--
-- sysfs class
--


object "class" {

	-- open
	constructor "open" {
		c_call "class *" "sysfs_open_class" { "const char *", "name" }
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
	struct dlist *clsdevlist = *(struct dlist **) lua_touserdata(L, lua_upvalueindex(1));
	struct sysfs_class_device *device;

	if ((device = dlist_next(clsdevlist)) != NULL) {
		lua_pushlightuserdata(L, device);
		return 1;
	} else {
		return 0;
	}
}
]]
},

	-- get a list of devices
	method "for_each_device" {
		c_source[[
  struct dlist **clsdevlist = (struct dlist **) lua_newuserdata(L, sizeof(struct dlist *));

  *clsdevlist = sysfs_get_class_devices(${this});

  if (clsdevlist) {
		dlist_start(*clsdevlist);
		lua_pushcclosure(L, class_device_iter, 1);
		return 1;
  } 
		]],
	},
}
