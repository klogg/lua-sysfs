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
-- sysfs bus
--

-- typedefs
local typedefs = [[
typedef struct sysfs_bus sysfs_bus;
]]
c_source "typedefs" (typedefs)
-- pass extra C type info to FFI.
ffi_cdef (typedefs)

object "sysfs_bus" {

	userdata_type = "generic",
	no_weak_ref = true,

	-- open bus
	constructor "open" {
		c_call "sysfs_bus *" "sysfs_open_bus" { "const char *", "name" }
	},
	-- close bus
	destructor "close" {
		c_method_call "void" "sysfs_close_bus" {}
	},
	-- get device
	method "get_device" {
		c_method_call "sysfs_device *" "sysfs_get_bus_device" {
						"const char *", "id"
		}
	},
	-- sysfs device iterator
	method "get_devices" {
		c_source [[
  lua_sysfs_iterator(${this}, sysfs_get_bus_devices, lua_sysfs_device_iterator);
]],
	},
	-- get driver
	method "get_driver" {
		c_method_call "sysfs_driver *" "sysfs_get_bus_driver" {
						"const char *", "drvname"
		}
	},
	-- sysfs driver iterator
	method "get_drivers" {
		c_source [[
  lua_sysfs_iterator(${this}, sysfs_get_bus_drivers, lua_sysfs_driver_iterator);
]],
	},
}
