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
-- sysfs driver
--

-- typedefs
local typedefs = [[
typedef struct sysfs_driver sysfs_driver;
]]
c_source "typedefs" (typedefs)
-- pass extra C type info to FFI.
ffi_cdef (typedefs)

-- internal functions
c_source "src" {
[[
/* internal sysfs driver iterator function */
static int lua_sysfs_driver_iterator(lua_State *L) {
	lua_sysfs_iterator_run(sysfs_driver, obj_type_sysfs_driver_push);
}
]]
}

object "sysfs_driver" {
	userdata_type = "generic",
	no_weak_ref = true,

	-- open
	constructor "open" {
		c_call "sysfs_driver *" "sysfs_open_driver" {
						"const char *", "bus_name",
						"const char *", "drv_name"
		}
	},
	-- close
	destructor "close" {
		c_method_call "void" "sysfs_close_driver" {}
	},
	-- open path
	constructor "open_path" {
		c_call "sysfs_driver *" "sysfs_open_driver_path" {
						"const char *", "path",
		}
	},
	-- get attribute
	method "get_attr" {
		c_method_call "sysfs_attribute *" "sysfs_get_driver_attr" {
						"const char *", "name"
		}
	},
	-- sysfs get attributes iterator
	method "get_attributes" {
	c_source [[
  lua_sysfs_iterator(${this}, sysfs_get_driver_attributes, lua_sysfs_attribute_iterator);
]]
        },
	-- sysfs get devices iterator
	method "get_devices" {
	c_source [[
  lua_sysfs_iterator(${this}, sysfs_get_driver_devices, lua_sysfs_device_iterator);
]]
        },
	--
	-- lua binding specific methods for accessing 'struct sysfs_driver' members
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
}
