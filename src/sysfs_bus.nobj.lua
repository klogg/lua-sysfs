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
typedef struct sysfs_bus bus;
]]
c_source "typedefs" (typedefs)
-- pass extra C type info to FFI.
ffi_cdef (typedefs)

object "bus" {

	userdata_type = "simple ptr",

	-- open bus
	constructor "open" {
		c_call "bus *" "sysfs_open_bus" { "const char *", "name" }
	},
	-- close bus
	destructor "close" {
		c_method_call "void" "sysfs_close_bus" {}
	},
	-- sysfs device iterator
	method "get_devices" {
		c_source[[
  struct dlist *list;

  list = sysfs_get_bus_devices(${this});

  if (list) {
		dlist_start(list);
		lua_pushlightuserdata(L, list);
		lua_pushcclosure(L, lua_sysfs_device_iterator, 1);
		return 1;
  }
		]],
	},
}
